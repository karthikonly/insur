require 'csv'
namespace :load do

  desc "Load all the states information to database"
  task province: :environment do
    CSV.foreach('db/states.csv', headers: true) do |row|
      p = Province.where(name: row['State'], symbol: row['Abbreviation'], country: "USA").first_or_create!
      puts "state: #{row['State']}, code: #{row['Abbreviation']}" if p
    end
  end

end
