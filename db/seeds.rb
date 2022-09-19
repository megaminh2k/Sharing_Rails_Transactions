# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

count = 1
30.times do
  name = Faker::Name.name
  email = "user-" + count.to_s + "@gmail.com"
  money = 5000000
  User.create!(name: name, email: email, money: money)
end
