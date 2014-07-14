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
task :regenerate_schemas do
  # debugger
  base_object = JSON.parse(File.new(File.join(PROJECT_ROOT,'lib','base-statement.json')).read)
  snippets = Dir.glob(File.join(PROJECT_ROOT,'lib','snippets','*base.json'))
  snippets.each do |snippet|
    object_name = snippet[/\/([^\/]+)-base.json/,1]
    snippet_data = JSON.parse(File.new(snippet).read)
    combined_data = {}.merge(snippet_data).merge(base_object)
    combined_data['properties']['data']['items'] = {
        "$ref" => "includes/#{object_name}-data-object.json"
      }
    # write file
    File.open(File.join(PROJECT_ROOT,'schemas',"#{object_name}-schema.json"),'w') { |file| file.puts JSON.pretty_generate(combined_data) }
  end
end


