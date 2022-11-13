workspace(name = "com_envoyproxy_protoc_gen_validate")

load("//bazel:repositories.bzl", "pgv_dependencies")

pgv_dependencies()

load("//bazel:python_dependencies.bzl", "pgv_python_dependencies")

pgv_python_dependencies()

load("//bazel:java_dependencies.bzl", "pgv_java_dependencies")

pgv_java_dependencies()

load("//bazel:dependency_imports.bzl", "pgv_dependency_imports")

pgv_dependency_imports()

load("//:dependencies.bzl", "go_third_party")

# gazelle:repository_macro dependencies.bzl%go_third_party
go_third_party()
