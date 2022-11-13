load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
load("@pgv_pip_deps//:requirements.bzl", pip_dependencies = "install_deps")

GO_VERSION = "1.19.3"

def pgv_dependency_imports():
    # Import @com_google_protobuf's dependencies.
    protobuf_deps()

    # Import @pgv_pip_deps defined by python/requirements.in.
    pip_dependencies()

    # Import rules for the Go compiler.
    _pgv_go_dependencies()

    # Setup rules_proto.
    rules_proto_dependencies()
    rules_proto_toolchains()

def _pgv_go_dependencies():
    go_rules_dependencies()
    go_register_toolchains(
        version = GO_VERSION,
    )
    gazelle_dependencies()
