require 'spec_helper'
require 'json_validation'
require 'openc_json_schema_formats'

def directory
  if ENV['TEST_ALL']
    '**'
  else
    'sample-data'
  end
end

describe "open-schemas" do
  %w(schemas build).each do |directory|
    Dir.glob(File.join(directory, '**', '*.json')).each do |path|
      data = JSON.parse(File.read(path))
      metaschema = JSON::Validator.validator_for_name(data['$schema']).metaschema
      context "when using JsonSchema" do
        it "#{path} should be a valid schema" do
          error = Openc::JsonSchema.validate(metaschema, data)
          expect(error).to be(nil)
        end
      end

      pending "when using JsonValidator" do
        # This is pending https://github.com/inglesp/json_validation/issues/1
        it "#{path} should be a valid schema" do
          valid = JsonValidation.load_validator(metaschema).validate(data)
          expect(valid).to be(true)
        end
      end
    end
  end

  Dir.glob(File.join('spec', directory, 'valid', '*.json')).each do |path|
    data = JSON.parse(File.read(path))
    filename = File.basename(path)
    match = filename.match(/(.*?)(_[a-z-]+)?-\d\d.json/)
    data_type = match[1]
    schema_path = File.join('schemas', "#{data_type}-schema.json")

    context "when using JsonSchema" do
      it "should validate valid json at #{path}" do
        error = Openc::JsonSchema.validate(schema_path, data)
        expect(error).to be(nil)
      end
    end

    context "when using JsonValidation" do
      it "should validate valid json at #{path}" do
        passed = JsonValidation.load_validator(schema_path).validate(data)
        expect(passed).to be(true)
      end
    end
  end

  Dir.glob(File.join('spec', directory, 'valid', 'includes', '*.json')).each do |path|
    data = JSON.parse(File.read(path))
    filename = File.basename(path)
    match = filename.match(/(.*)-\d\d.json/)
    data_type = match[1]
    schema_path = File.join('schemas', 'includes', "#{data_type}.json")

    context "when using JsonSchema" do
      it "should validate valid json at #{path}" do
        error = Openc::JsonSchema.validate(schema_path, data)
        expect(error).to be(nil)
      end
    end

    context "when using JsonValidation" do
      it "should validate valid json at #{path}" do
        passed = JsonValidation.load_validator(schema_path).validate(data)
        expect(passed).to be(true)
      end
    end
  end

  Dir.glob(File.join('spec', directory, 'invalid', '*')).each do |dir|
    data_type = File.basename(dir)

    unless data_type == 'includes'
      Dir.glob(File.join(dir, '*.json')).each do |path|
        filename = File.basename(path)
        match = filename.match(/(.*)-(.*).json/)
        error_type = match[1]
        error_path = match[2]

        specify "invalid #{data_type} should fail validation with #{error_type} at #{error_path}" do
          data = JSON.parse(File.read(path))
          error = Openc::JsonSchema.validate(File.join('schemas', "#{data_type}-schema.json"), data)
          expect(error).to_not eq(nil), "expected error for #{path}"
          expect(error[:type].to_s).to eq(error_type)
          expect(error[:path]).to eq(error_path)
        end
      end
    end
  end

  Dir.glob(File.join('spec', directory, 'invalid', 'includes', '*')).each do |dir|
    data_type = File.basename(dir)

    Dir.glob(File.join(dir, '*.json')).each do |path|
      filename = File.basename(path)
      match = filename.match(/(.*)-(.*).json/)
      error_type = match[1]
      error_path = match[2]

      specify "invalid #{data_type} should fail validation with #{error_type} at #{error_path}" do
        data = JSON.parse(File.read(path))
        error = Openc::JsonSchema.validate(File.join('schemas', 'includes', "#{data_type}.json"), data)
        expect(error).to_not eq(nil), "expected error for #{path}"
        expect(error[:type].to_s).to eq(error_type)
        expect(error[:path]).to eq(error_path)
      end
    end
  end
end
