require 'json-schema'

def find_schema(path)
  filename = File.basename(path)

  raise "Invalid filename for sample data at #{path}" unless filename =~ /-\d\d\.json$/

  schema_name = filename.sub(/-\d\d\.json$/, '-schema.json')
  schema_path = File.join('schemas', schema_name)

  raise "Could not find schema for sample data at #{path}" unless File.exists?(schema_path)

  schema_path
end

successes = 0
failures = 0

Dir.glob(File.join('sample-data', 'valid', '*')).each do |path|
  data = File.open(path) {|f| f.read}
  if JSON::Validator.validate(find_schema(path), data)
    successes += 1
  else
    failures += 1
    puts "#{path} was invalid"
  end
end

Dir.glob(File.join('sample-data', 'invalid', '*')).each do |path|
  data = File.open(path) {|f| f.read}
  if JSON::Validator.validate(find_schema(path), data)
    failures += 1
    puts "#{path} was valid"
  else
    successes += 1
  end
end

puts "There were #{successes} successes and #{failures} failures."
