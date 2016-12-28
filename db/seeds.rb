# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Component_list = [
  'Application Logs',
  'Asset Management',
  'Bookmark Management',
  'Catalog Management',
  'Configurations',
  'Content Delivery Network',
  'Management',
  'Expiry Management',
  'Licensing',
  'Market Management',
  'Offer Management',
  'Operator Management',
  'Purchase Management',
  'Rental Management',
  'Route Management',
  'Session Management',
  'Streaming Resource Management',
  'Subscriber Management',
  'Subscription Management',
  'Trigger Management',
  'Infrastructure',
  'Monitoring',
  'Service API',
  'AMI API',
  'Common',
  'Test',
  'RoR Framework'
]

def load_components
  Component_list.each do |component|
    Component.find_or_create_by(name: component)
    puts component
  end 
end

def process_file(path, name, level)
  # puts "File: name: #{name}, folder: #{path}, loc: 0, review_done: false, type: nil"
  print_levels('F:', level)
  puts "#{name}:#{File.extname(name)[1..-1]}"
  FileInfo.find_or_create_by(folder: path, name: name) do |fi|
    fi.loc = nil
    fi.review_done = false
    fi.type = File.extname(name)[1..-1]
  end
end

def print_levels(header, level)
  print header
  print ' ' * level * 2
end

def process_folder(root, path, level = 0)
  folder_path = [root, path].join('/')
  return unless File.directory? folder_path
  # return if level > 1
  print_levels('D:', level)
  puts "#{path}"

  entries = Dir.entries(folder_path)
  entries.each do |entry|
    full_path = [folder_path, entry].join('/')
    rel_path = [path, entry].join('/')
    if /^\..*$/ =~ entry
      # puts "skipping #{full_path}"
    elsif File.directory? full_path
      process_folder(root, rel_path, level+1)
    else
      process_file(path, entry, level+1)
    end
  end
end

def load_file_infos
  process_folder("/Users/karthik/mdms/monaco", "")
end

def main
  load_components
  load_file_infos
end

main