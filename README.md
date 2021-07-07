# openc-schema

JSON Schema to validate data before sending it to be **ingested into** OpenCorporates.

Originally these files were designed for use by external developers, along with the [openc_bot gem](https://github.com/openc/openc_bot),  with OpenCorporates encouraging anyone to join in with writing bots for data gathering and ingestion. Lately we have moved away from that approach, and all meaningful use of these schema files is confined to bots living in our own private repos.

Looking for a schema description of the OpenCorporates API? We're working on something, so let us know you're interested (But this repo is not it!) 

## Usage

Include it in your Gemfile:

```
gem "openc-schema", git: "https://github.com/openc/openc-schema", tag: "vx.y.z"
```

Then get the path to the schema files:

```
File.join(Gem.loaded_specs['openc-schema'].full_gem_path, "schemas/company-schema.json")
```

If you are using a library that uses this gem, you must include this gem along with the library in your Gemfile.
This will be required until this gem is hosted in a proper gem registry.

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
