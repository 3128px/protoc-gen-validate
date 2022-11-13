load("@rules_jvm_external//:defs.bzl", "maven_install")

def pgv_java_dependencies():
    maven_install(
        artifacts = [
            "com.google.code.gson:gson:2.8.9",
            "com.google.errorprone:error_prone_annotations:2.3.2",
            "com.google.j2objc:j2objc-annotations:1.3",
            "com.google.guava:guava:31.1-jre",
            "commons-validator:commons-validator:1.6",
            "com.google.re2j:re2j:1.7",
        ],
        repositories = [
            "https://repo1.maven.org/maven2",
            "https://repo.maven.apache.org/maven2",
        ],
    )
