require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'json'
require 'fileutils'

desc 'Rewrite JSON files with consistent formatting'
task :format_json do
  [
    ['schemas'],
    ['schemas', 'includes'],
    ['spec', '**'],
  ].each do |parts|
    Dir.glob(File.join(*parts, '*.json')).each do |path|
      data = JSON.parse(File.read(path))
      File.open(path, 'w') do |f|
        f.puts(JSON.pretty_generate(data))
      end
    end
  end
end

desc 'Write schema files with embedded references'
task :build do
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
      unless ref.start_with?('#/definitions/')
        name = File.basename(ref).chomp('.json')
        value['$ref'] = "#/definitions/#{name}"
        define(name, File.expand_path(ref, File.dirname(path)), definitions)
      end
    end
    value
  end

  def process_object(value, path, definitions)
    if value.key?('properties')
      process_properties(value['properties'], path, definitions)
    else
      keyword = (value.keys & ['allOf', 'anyOf', 'oneOf']).first
      if keyword
        value[keyword].each do |subschema|
          process_object(subschema, path, definitions)
        end
      else
        process_value(value, path, definitions)
      end
    end
    value
  end

  def process_properties(properties, path, definitions)
    properties.each do |_,value|
      if value.key?('items')
        process_object(value['items'], path, definitions)
      else
        process_object(value, path, definitions)
      end
    end
    properties
  end

  def process_schema(path, definitions)
    schema = JSON.load(File.read(path))
    if schema.key?('definitions')
      schema['definitions'].each do |_,definition|
        process_object(definition, path, definitions)
      end
      definitions.merge!(schema['definitions'])
    end
    process_object(schema, path, definitions)
  end

  all_definitions = {}
  generated = []

  Dir[File.join('schemas', '*.json')].each do |path|
    definitions = {} # passed by reference
    schema = process_schema(path, definitions).merge('definitions' => definitions)
    all_definitions.merge!(definitions) # cache definitions across schema
    File.open(File.join('build', File.basename(path)), 'w') do |f|
      f.write(JSON.pretty_generate(schema))
    end
    generated << File.basename(path)
  end

  Dir[File.join('build', '*.json')].each do |path|
    FileUtils.rm(path) unless generated.include?(File.basename(path))
  end
end
