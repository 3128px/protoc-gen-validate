REPOSITORY_LOCATIONS_SPEC = dict(
    bazel_skylib = dict(
        version = "1.3.0",
        sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
        urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/{version}/bazel-skylib-{version}.tar.gz"],
    ),
    bazel_gazelle = dict(
        version = "0.26.0",
        sha256 = "501deb3d5695ab658e82f6f6f549ba681ea3ca2a5fb7911154b5aa45596183fa",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/v{version}/bazel-gazelle-v{version}.tar.gz"],
    ),
    com_google_protobuf = dict(
        version = "21.7",
        sha256 = "e07046fbac432b05adc1fd1318c6f19ab1b0ec0655f7f4e74627d9713959a135",
        strip_prefix = "protobuf-{version}",
        urls = ["https://github.com/protocolbuffers/protobuf/releases/download/v{version}/protobuf-all-{version}.tar.gz"],
    ),
    com_googlesource_code_re2 = dict(
        version = "2022-06-01",
        sha256 = "f89c61410a072e5cbcf8c27e3a778da7d6fd2f2b5b1445cd4f4508bee946ab0f",
        strip_prefix = "re2-{version}",
        urls = ["https://github.com/google/re2/archive/{version}.tar.gz"],
    ),
    io_bazel_rules_go = dict(
        version = "0.35.0",
        sha256 = "099a9fb96a376ccbbb7d291ed4ecbdfd42f6bc822ab77ae6f1b5cb9e914e94fa",
        urls = ["https://github.com/bazelbuild/rules_go/releases/download/v{version}/rules_go-v{version}.zip"],
    ),
    rules_python = dict(
        version = "0.13.0",
        sha256 = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4",
        strip_prefix = "rules_python-{version}",
        urls = ["https://github.com/bazelbuild/rules_python/archive/{version}.tar.gz"],
    ),
    rules_proto = dict(
        version = "4.0.0",
        sha256 = "66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1",
        strip_prefix = "rules_proto-{version}",
        urls = ["https://github.com/bazelbuild/rules_proto/archive/refs/tags/{version}.tar.gz"],
    ),
    rules_jvm_external = dict(
        version = "4.5",
        sha256 = "6e9f2b94ecb6aa7e7ec4a0fbf882b226ff5257581163e88bf70ae521555ad271",
        strip_prefix = "rules_jvm_external-{version}",
        urls = ["https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/{version}.tar.gz"],
    ),
)
