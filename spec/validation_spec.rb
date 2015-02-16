require 'spec_helper'

describe "open-schemas" do
  Dir.glob(File.join('spec','sample-data', 'valid', '*.json')).each do |path|
    it "should validate valid json at #{path}" do
      data = JSON.parse(File.read(path))

      filename = File.basename(path)
      match = filename.match(/(.*)-\d\d.json/)
      data_type = match[1]

      error = Openc::JsonSchema.validate(File.join('schemas', "#{data_type}-schema.json"), data)
      expect(error).to be(nil)
    end
  end

  Dir.glob(File.join('spec','sample-data', 'valid', 'includes', '*.json')).each do |path|
    it "should validate valid json at #{path}" do
      data = JSON.parse(File.read(path))

      filename = File.basename(path)
      match = filename.match(/(.*)-\d\d.json/)
      data_type = match[1]

      error = Openc::JsonSchema.validate(File.join('schemas', 'includes', "#{data_type}.json"), data)
      expect(error).to be(nil)
    end
  end

  Dir.glob(File.join('spec', 'sample-data', 'invalid', '*')).each do |dir|
    data_type = File.basename(dir)

    unless data_type == 'includes'
      Dir.glob(File.join(dir, '*.json')).each do |path|
        filename = File.basename(path)
        match = filename.match(/(.*)-(.*).json/)
        error_type = match[1]
        error_path = match[2]

        specify "invalid #{data_type} should fail vaildation with #{error_type} at #{error_path}" do
          data = JSON.parse(File.read(path))
          error = Openc::JsonSchema.validate(File.join('schemas', "#{data_type}-schema.json"), data)
          expect(error[:type].to_s).to eq(error_type)
          expect(error[:path]).to eq(error_path)
        end
      end
    end
  end

  Dir.glob(File.join('spec', 'sample-data', 'invalid', 'includes', '*')).each do |dir|
    data_type = File.basename(dir)

    Dir.glob(File.join(dir, '*.json')).each do |path|
      filename = File.basename(path)
      match = filename.match(/(.*)-(.*).json/)
      error_type = match[1]
      error_path = match[2]

      specify "invalid #{data_type} should fail vaildation with #{error_type} at #{error_path}" do
        data = JSON.parse(File.read(path))
        error = Openc::JsonSchema.validate(File.join('schemas', 'includes', "#{data_type}.json"), data)
        expect(error[:type].to_s).to eq(error_type)
        expect(error[:path]).to eq(error_path)
      end
    end
  end
end
