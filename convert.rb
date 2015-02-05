require 'json'
require 'openc/json_schema'

FileUtils.rm_r(File.join('spec', 'sample-data', 'invalid-2'))

Dir.glob(File.join('spec','sample-data', 'invalid', '*json')).each do |path|
  filename = File.basename(path)
  schema_name = filename.sub(/-\d\d\.json$/, '')
  new_dir = File.join('spec', 'sample-data', 'invalid-2', schema_name)
  FileUtils.mkdir_p(new_dir)
  data = JSON.parse(File.read(path))
  schema_filename = schema_name + '-schema.json'
  error = Openc::JsonSchema.validate(schema_filename, 'schemas', data)

  if error.nil?
    puts "got no error for #{path}"
  else
    new_filename = "#{error[:type]}-#{error[:path]}.json"
    new_path = File.join(new_dir, new_filename)
    if File.exists?(new_path)
      puts "duplicate error (#{error}) for #{path}"
    else
      File.open(new_path, 'w') {|f| f.write(JSON.pretty_generate(data))}
    end
  end
end
