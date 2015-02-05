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

  Dir.glob(File.join('spec', 'sample-data', 'invalid', '*')).each do |dir|
    data_type = File.basename(dir)

    Dir.glob(File.join(dir, '*')).each do |path|
      filename = File.basename(path)
      match = filename.match(/(.*)-(.*).json/)
      error_type = match[1]
      property_path = match[2]

      specify "invalid #{data_type} should fail vaildation with #{error_type} at #{property_path}" do
        data = JSON.parse(File.read(path))
        error = Openc::JsonSchema.validate("#{data_type}-schema.json", 'schemas', data)
        expect(error).not_to be(nil)
      end
    end
  end
end

def get_schema_path(path)
  filename = File.basename(path)

  raise "Invalid filename for sample data at #{path}" unless filename =~ /-\d\d\.json$/

  schema_name = filename.sub(/-\d\d\.json$/, '-schema.json')
  File.join('schemas', schema_name)
end
