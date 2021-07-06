lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "openc-schema"
  spec.version       = "1.0.0.dev"
  spec.authors       = ["OpenCorporates dev team"]

  spec.summary       = %q{JSON Schema to validate data before sending to OpenCorporates.}
  spec.homepage      = "https://github.com/openc/openc-schema"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)|\.ruby-version/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_runtime_dependency "openc-json_schema", "= 0.0.14"
  spec.add_runtime_dependency "json_validation", "= 0.1.0"
  spec.add_runtime_dependency "openc_json_schema_formats", "= 0.1.3"
end
