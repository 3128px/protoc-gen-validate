load("@rules_python//python:pip.bzl", "pip_parse")

def pgv_python_dependencies():
    pip_parse(
        name = "pgv_pip_deps",
        requirements_lock = "@com_envoyproxy_protoc_gen_validate//python:requirements.txt",
        extra_pip_args = ["--require-hashes"],
    )
