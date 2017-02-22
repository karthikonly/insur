require 'csv'
namespace :load do

  desc "Load all the states information to database"
  task province: :environment do
    CSV.foreach('db/states.csv', headers: true) do |row|
      p = Province.where(name: row['State'], symbol: row['Abbreviation'], country: "USA").first_or_create!
      puts "state: #{row['State']}, code: #{row['Abbreviation']}" if p
    end
  end

  desc "Load all the vehicles information to database"
  task vehicles: :environment do
    File.open('db/vehicles.sql').each do |line|
      trimmed = line.strip[1..-3]
      entries = trimmed.split(',').map {|x| x.strip}
      puts "year: #{entries[0]}, make: #{entries[1][1..-2]}, model: #{entries[2][1..-2]}"
      v = Vehicle.new({year: entries[0].to_i, make: entries[1][1..-2], model: entries[2][1..-2]})
      puts "Model failed to save due to : #{v.errors.messages.inspect}" unless v.save
    end
  end
end
