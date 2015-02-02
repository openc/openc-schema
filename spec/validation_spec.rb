require 'spec_helper'

describe "open-schemas" do
  Dir.glob(File.join('spec','sample-data', 'valid', '*json')).each do |path|
    it "should validate valid json at #{path}" do
      data = JSON.parse(File.read(path))
      schema = get_schema_path(path)
      error = Openc::JsonSchema.validate(File.basename(path), File.dirname(path), data)
      expect(error).to be(nil)
    end

  end

  Dir.glob(File.join('spec','sample-data', 'invalid', '*json')).each do |path|
    it "should not validate invalid json at #{path}" do
      data = JSON.parse(File.read(path))
      schema = get_schema_path(path)
      error = Openc::JsonSchema.validate(File.basename(path), File.dirname(path), data)
      expect(error).to be(nil)
    end
  end
end

def get_schema_path(path)
  filename = File.basename(path)

  raise "Invalid filename for sample data at #{path}" unless filename =~ /-\d\d\.json$/

  schema_name = filename.sub(/-\d\d\.json$/, '-schema.json')
  File.join('schemas', schema_name)
end
