load(":pgv_http_archive.bzl", "pgv_http_archive")
load(":external_deps.bzl", "load_repository_locations")
load(":repository_locations.bzl", "REPOSITORY_LOCATIONS_SPEC")

REPOSITORY_LOCATIONS = load_repository_locations(REPOSITORY_LOCATIONS_SPEC)

def pgv_dependencies():
    external_http_archive(
        name = "bazel_skylib",
    )
    external_http_archive(
        name = "bazel_gazelle",
    )

    # TODO(dio): To use precompiled protoc when available.
    external_http_archive(
        name = "com_google_protobuf",
        # This patch mostly to enable "protobuf_python_genproto".
        patches = ["@com_envoyproxy_protoc_gen_validate//bazel:protobuf.patch"],
        patch_args = ["-p1"],
    )
    external_http_archive(
        name = "com_googlesource_code_re2",
    )
    external_http_archive(
        name = "io_bazel_rules_go",
    )
    external_http_archive(
        name = "rules_python",
    )
    external_http_archive(
        name = "rules_proto",
    )
    external_http_archive(
        name = "rules_jvm_external",
    )

def external_http_archive(name, **kwargs):
    pgv_http_archive(
        name,
        locations = REPOSITORY_LOCATIONS,
        **kwargs
    )
