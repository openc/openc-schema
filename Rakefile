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

desc 'Rewrite schema files with consistent formatting'
task :format_schemas do
  def format_schema(path)
    data = JSON.parse(File.read(path))
    File.open(path, 'w') do |f|
      f.write(JSON.pretty_generate(data))
    end
  end

  Dir.glob(File.join('schemas', '*.json')).each {|path| format_schema(path)}
  Dir.glob(File.join('schemas', 'includes', '*.json')).each {|path| format_schema(path)}
end
