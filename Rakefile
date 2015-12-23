require "rubygems"

PROJECT_ROOT = File.expand_path("..", __FILE__)

require "rspec/core/rake_task"
# require 'debugger'

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = true
end

task :default => :spec

## dist

require "json"

desc "Regenerate schema files from snippets and reference files"
task :regenerate_data_object_schemas do
  spacers = '='*20
  puts "Regenerating OpenCorporates DataObject schemas"
  puts spacers
  base_object = JSON.parse(File.new(File.join(PROJECT_ROOT,'lib','base-statement.json')).read)
  snippets = Dir.glob(File.join(PROJECT_ROOT,'lib','snippets','*base.json'))
  snippets.each do |snippet|
    object_name = snippet[/\/([^\/]+)-base.json/,1]
    snippet_data = JSON.parse(File.new(snippet).read)
    combined_data = {}.merge(snippet_data).merge(base_object)
    combined_data['properties']['data']['items'] = {
        "$ref" => "includes/#{object_name}-data-object.json"
      }
    File.open(File.join(PROJECT_ROOT,'schemas',"#{object_name}-schema.json"),'w') { |file| file.puts JSON.pretty_generate(combined_data) }
    puts "Generated schema: '#{object_name}-schema.json'"
  end
  puts spacers
  puts "Finished regenerating schemas.\nNow running validation specs"
  puts spacers
  Rake::Task['run_validation_specs'].invoke
end

task :run_validation_specs do
  Rake::Task['default'].invoke
end

def format_json(path)
  data = JSON.parse(File.read(path))
  File.open(path, 'w') do |f|
    f.write(JSON.pretty_generate(data))
  end
end

desc 'Rewrite schema files with consistent formatting'
task :format_schemas do
  Dir.glob(File.join('schemas', '*.json')).each {|path| format_json(path)}
  Dir.glob(File.join('schemas', 'includes', '*.json')).each {|path| format_json(path)}
end

desc 'Rewrite sample data files with consistent formatting'
task :format_sample_data do
  Dir.glob(File.join('spec', '**', '*.json')).each {|path| format_json(path)}
end

desc 'Write schema files with embedded references'
task :embed_references do
  # @see https://github.com/influencemapping/whos_got_dirt-gem/blob/master/Rakefile

  def define(name, path, definitions)
    unless definitions.key?(name)
      definitions[name] = {} # to avoid recursion
      definitions[name] = process_schema(path, definitions)
    end
  end

  def process_value(value, path, definitions)
    if value.key?('$ref')
      ref = value['$ref']
      name = File.basename(ref).chomp('.json')
      value['$ref'] = "#/definitions/#{name}"
      define(name, File.expand_path(ref, File.dirname(path)), definitions)
    elsif value.key?('properties')
      process_properties(value['properties'], path, definitions)
    end
  end

  def process_properties(properties, path, definitions)
    properties.each do |_,value|
      if value.key?('items')
        process_value(value['items'], path, definitions)
      elsif value.key?('properties')
        process_properties(value['properties'], path, definitions)
      else
        process_value(value, path, definitions)
      end
    end
  end

  def process_schema(path, definitions)
    schema = JSON.load(File.read(path))
    if schema.key?('properties')
      process_properties(schema['properties'], path, definitions)
    elsif schema.key?('oneOf')
      schema['oneOf'].each do |subschema|
        if subschema.key?('properties')
          process_properties(subschema['properties'], path, definitions)
        end
      end
    end
    schema
  end

  metaschema = JSON::Schema::Draft4.new.metaschema

  all_definitions = {}

  Dir[File.join('schemas', '*.json')].each do |path|
    definitions = {} # passed by reference
    schema = process_schema(path, definitions).merge('definitions' => definitions)
    all_definitions.merge!(definitions) # cache definitions across schema

    begin
      validator = JSON::Validator.new(metaschema, schema, clear_cache: false)
      validator.validate
    rescue JSON::Schema::ValidationError => e
      e.message = "#{File.basename(path)}: #{e.message}"
      raise e
    end

    File.open(File.join('build', File.basename(path)), 'w') do |f|
      f.write(JSON.pretty_generate(schema))
    end
  end
end
