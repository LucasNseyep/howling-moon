# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Deleting all thoughts"
Thought.delete_all

jeffrey = User.create(email: "a@abc.com", password:"1234567", username: "theBeztos" )

puts "Creating thoughts"
counter = 1
3.times do
  Thought.create!(title: "Thought #{counter}", content: "sakdjkas lk asjdkljd bbbbbbb lkasjdlksajdkl", user: jeffrey)
  counter += 1
  puts "Thought #{counter} created"
end

puts "All done!"
