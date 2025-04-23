#!/usr/bin/env ruby
require 'yaml'

# Read and parse the YAML file
yaml_file = File.join(File.dirname(__FILE__), 'scaffold.yaml')
config = YAML.load_file(yaml_file)

# Process each table and generate scaffold commands
commands = []

config['tables'].each do |table|
  table_name = table['table_name']
  attributes = []
  
  table['columns'].each do |column|
    column.each do |name, type|
      attributes << "#{name}:#{type}"
    end
  end
  
  command = "rails generate scaffold #{table_name.capitalize} #{attributes.join(' ')}"
  commands << command
end

# Output the commands to a shell script
script_path = File.join(File.dirname(__FILE__), 'run_scaffolds.sh')
File.open(script_path, 'w') do |file|
  file.puts "#!/bin/bash"
  file.puts "# Generated scaffold commands"
  commands.each do |cmd|
    file.puts cmd
  end
  file.puts "rails db:migrate"
end

# Make the script executable
File.chmod(0755, script_path)

puts "Generated scaffold commands in run_scaffolds.sh"
puts "Run the following to execute:"
puts "  ./run_scaffolds.sh"