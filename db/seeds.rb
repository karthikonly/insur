# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User_list = [
  { 
    name: "Admin",
    email: "admin@insurance.com",
    password: "password",
    password_confirmation: "password"
  }
]

def load_admin_user
  User_list.each do |user|
    User.find_or_create_by(name: user[:name])
  end 
end

def main
  load_admin_user
end

main