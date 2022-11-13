name := protoc-gen-validate

# Currently, harness tests only run on C++ and Go.
# TODO(dio): Run harness to all supported languages.
HARNESS_LANGUAGES ?= cc go

# Root dir returns absolute path of current directory. It has a trailing "/".
root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(root_dir)hack/build/Help.mk

# Include versions of tools we build or fetch on-demand.
include $(root_dir)hack/build/Tools.mk

# Local cache directory.
CACHE_DIR ?= $(root_dir).cache

# Directory of Go tools.
go_tools_dir := $(CACHE_DIR)/tools/go

# Directory of prepackaged tools (e.g. protoc).
prepackaged_tools_dir := $(CACHE_DIR)/tools/prepackaged

# Currently we resolve it using which. But more sophisticated approach is to use infer GOROOT.
go     := $(shell which go)
goarch := $(shell $(go) env GOARCH)
goexe  := $(shell $(go) env GOEXE)
goos   := $(shell $(go) env GOOS)

current_binary_path := build/$(name)_$(goos)_$(goarch)
current_binary      := $(current_binary_path)/$(name)$(goexe)

export PATH := $(go_tools_dir)/bin:$(prepackaged_tools_dir)/bin:$(root_dir)$(current_binary_path):$(PATH)

# Disable cgo.
export CGOENABLED := 0

# Reference: https://developers.google.com/protocol-buffers/docs/reference/go/faq#namespace-conflict.
export GOLANG_PROTOBUF_REGISTRATION_CONFLICT := warn

# Prepackaged tools.
protoc := $(prepackaged_tools_dir)/bin/protoc

# Go based tools.
bazel         := $(go_tools_dir)/bin/bazelisk
buildifier    := $(go_tools_dir)/bin/buildifier
protoc-gen-go := $(go_tools_dir)/bin/protoc-gen-go
gosimports    := $(go_tools_dir)/bin/gosimports

test: $(bazelisk) ## Runs PGV tests
	$(bazel) test //tests/... --test_output=errors

# Harness executables.
go_harness   := $(root_dir)tests/harness/go/main/go-harness
cc_harness   := $(root_dir)tests/harness/cc/cc-harness

harness: $(go_harness) $(cc_harness) ## Runs PGV harness test
	@$(go) run tests/harness/executor/*.go $(addprefix -,$(HARNESS_LANGUAGES))

validate_pb_go := validate/validate.pb.go

build: $(current_binary) ## Builds PGV binary

bazel_files := WORKSPACE BUILD.bazel $(shell find . \( -name "*.bzl" -or -name "*.bazel" -or -name "BUILD" \) -not -path "./bazel-*" -not -path "./.cache")
all_nongen_go_sources := $(shell find . -name "*.go" -not -path "*.pb.go" -not -path "*.pb.validate.go" -not -path "./templates/go/file.go" -not -path "./bazel-*" -not -path "./.cache")
format: $(buildifier) $(gosimports)
	@$(buildifier) --lint=fix $(bazel_files)
	@$(go) mod tidy
	@$(go)fmt -s -w $(all_nongen_go_sources)
	@$(gosimports) -local $$(sed -ne 's/^module //gp' go.mod) -w $(all_nongen_go_sources)

check:
	@if [ ! -z "`git status -s`" ]; then \
		echo "The following differences will fail CI until committed:"; \
		git diff --exit-code; \
	fi

clean: ## Clean all build and test artifacts
	@rm -f $(validate_pb_go)
	@rm -f $(current_binary) $(shell find tests \( -name "*.pb.go" -or -name "*.pb.validate.go" \))
	@rm -f $(go_harness) $(cc_harness)

# Shortcuts.
gazelle: $(bazel) ## Runs gazelle against the codebase to generate Bazel BUILD files
	@$(bazel) run //:gazelle -- update-repos -from_file=go.mod -prune -to_macro=dependencies.bzl%go_third_party
	@$(bazel) run //:gazelle

bazel-build: $(bazel) ## Build PGV binary using bazel
	@$(bazel) build //:$(name)
	@mkdir -p $(current_binary_path)
	@cp -f bazel-bin/$(name)_/$(name)$(goexe) $(current_binary)
	@chmod +x $(current_binary)

# Internal helpers.
build/$(name)_%/$(name)$(goexe): $(validate_pb_go)
	@GOBIN=$(root_dir)$(current_binary_path) $(go) install .

$(validate_pb_go): $(protoc) $(protoc-gen-go) validate/validate.proto
	@$(protoc) -I . --go_opt=paths=source_relative --go_out=. $(filter %.proto,$^)

# List of harness test cases for Go.
tests_harness_cases_go := \
	/harness \
	/harness/cases \
	/harness/cases/other_package \
	/harness/cases/yet_another_package

$(go_harness): $(tests_harness_cases_go)
	@cd tests/harness/go/main && $(go) build -o $@ .

$(cc_harness):
	@bazel build //tests/harness/cc:cc-harness
	@cp bazel-bin/tests/harness/cc/cc-harness $@
	@echo $(cc_harness)

$(tests_harness_cases_go): $(current_binary)
	$(call generate-test-cases-go,tests$@)

# Catch all rules for Go-based tools.
$(go_tools_dir)/bin/%:
	@GOBIN=$(go_tools_dir)/bin $(go) install $($(notdir $@)@v)

# Generates a test-case for Go.
define generate-test-cases-go
	@cd $1 && \
	mkdir -p go && \
	$(protoc) \
		-I . \
		-I $(root_dir) \
		--go_opt=paths=source_relative \
		--go_out=go \
		--validate_opt=paths=source_relative \
		--validate_out=lang=go:go \
		*.proto
endef

# Install protoc from github.com/protocolbuffers/protobuf.
protoc-os      := $(if $(findstring $(goos),darwin),osx,$(goos))
protoc-arch    := $(if $(findstring $(goarch),arm64),aarch_64,x86_64)
protoc-version  = $(subst github.com/protocolbuffers/protobuf@v,$(empty),$($(notdir $1)@v))
protoc-archive  = protoc-$(call protoc-version,$1)-$(protoc-os)-$(protoc-arch).zip
protoc-url      = https://$(subst @,/releases/download/,$($(notdir $1)@v))/$(call protoc-archive,$1)
protoc-zip      = $(prepackaged_tools_dir)/$(call protoc-archive,$1)
$(protoc):
	@mkdir -p $(prepackaged_tools_dir)
ifeq ($(goos),linux)
	@curl -sSL $(call protoc-url,$@) -o $(call protoc-zip,$@)
	@unzip -oqq $(call protoc-zip,$@) -d $(prepackaged_tools_dir)
	@rm -f $(call protoc-zip,$@)
else
	@curl -sSL $(call protoc-url,$@) | tar xf - -C $(prepackaged_tools_dir)
	@chmod +x $@
endif
