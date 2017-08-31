# openc-schema

JSON Schema to validate data before sending to OpenCorporates.

## Tasks

Rewrite JSON files with consistent formatting:

    rake format_json

Write schema files with embedded references (for Docson):

    rake build

## Test

Run tests:

    rake

Run tests against JSON files under both `sample-data` and `additional-sample-data`:

    TEST_ALL=1 rake

## Releasing a new version

See the [wiki](https://wiki.opencorporates.com/dev/updating_openc-schema) (requires login).

Copyright (c) 2015 Chrinon Ltd, released under the MIT license
