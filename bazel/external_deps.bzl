DEPENDENCY_ANNOTATIONS = [
    # The dependency version. This may be either a tagged release (preferred)
    # or git SHA (as an exception when no release tagged version is suitable).
    "version",
]

def load_repository_locations(repository_locations_spec):
    locations = {}
    for key, location in _load_repository_locations_spec(repository_locations_spec).items():
        mutable_location = dict(location)
        locations[key] = mutable_location

        if "sha256" not in location or len(location["sha256"]) == 0:
            _fail_missing_attribute("sha256", key)

        if "version" not in location:
            _fail_missing_attribute("version", key)

        # Remove any extra annotations that we add, so that we don't confuse http_archive etc.
        for annotation in DEPENDENCY_ANNOTATIONS:
            if annotation in mutable_location:
                mutable_location.pop(annotation)

    return locations

def _fail_missing_attribute(attr, key):
    fail("The '%s' attribute must be defined for external dependency " % attr + key)

def _format_version(s, version):
    return s.format(version = version, dash_version = version.replace(".", "-"), underscore_version = version.replace(".", "_"))

# Generate a "repository location specification" from raw repository specification.
def _load_repository_locations_spec(repository_locations_spec):
    locations = {}
    for key, location in repository_locations_spec.items():
        mutable_location = dict(location)
        locations[key] = mutable_location

        # Fixup with version information.
        if "version" in location:
            if "strip_prefix" in location:
                mutable_location["strip_prefix"] = _format_version(location["strip_prefix"], location["version"])
            mutable_location["urls"] = [_format_version(url, location["version"]) for url in location["urls"]]
            if "license_url" in location:
                mutable_location["license_url"] = _format_version(location["license_url"], location["version"])
    return locations
