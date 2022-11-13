load("@rules_java//java:defs.bzl", "java_library")

java_library(
    name = "pgv",
    srcs = glob(["*.java"]),
    visibility = ["//visibility:public"],
    deps = [
        "@com_google_protobuf//:protobuf_java",
        "@com_google_protobuf//:protobuf_java_util",
        "@maven//:com_google_guava_guava",
        "@maven//:com_google_re2j_re2j",
        "@maven//:commons_validator_commons_validator",
    ],
)
