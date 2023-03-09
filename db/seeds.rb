# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Deleting all thoughts"
Thought.delete_all

lucas = User.create(email: "lucas.nseyep@gmail.com", password:"1234567", username: "Lucas" )

post_lewagon_collection = Collection.new(title:"Post Le Wagon")

puts "Creating thoughts"

puts "
⠀⠀⠀⠀⠀⢀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠰⡿⠿⠛⠛⠻⠿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣀⣄⡀⠀⠀⠀⠀⢀⣀⣀⣤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⣿⣿⣷⠀⠀⠀⠀⠛⠛⣿⣿⣿⡛⠿⠷⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠘⠿⠿⠋⠀⠀⠀⠀⠀⠀⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣿⣷⣄⠀⢶⣶⣷⣶⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠈⠙⠻⠗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣰⣿⣿⣿⠀⠀⠀⠀⢀⣀⣠⣤⣴⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣠⣾⣿⣿⣿⣥⣶⣶⣿⣿⣿⣿⣿⠿⠿⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠛⢿⣿⣿⣿⣿⣿⣿⡿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"


thought_1 = Thought.create!(
  title: "Post-LeWagon Coding",
  content: "I should keep coding after LeWagon. Interview prep only helps you practice for interviews.
  Keep working on cool personal projects (they're fun).
  And collaborate with people from the 1123, to keep practicing teamwork.",
  user: lucas,
  collection: post_lewagon_collection,
)
puts "Thought 1 created"

thought_2 = Thought.new(
  title: "Convo with Vicky",
  content: "Had a conversation with Vicky and talked about languages in the Carribean.
  We talked in depth about how demeaning the word 'patoie' is for African and Carribean languages.
  Why not create an app where we crowdsource information about languages from their speakers.
  Like how people speak Bamileke in Cameroon.",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_2.parent = thought_1
thought_2.save!
puts "Thought 2 created"

thought_3 = Thought.new(
  title: "Maggie Maps Plural",
  content: "Went out for drinks with Maggie and discussed this idea of maps with her.
  She talked about how we could use this to map music. Like what music was the world
  listening to a century or millenium ago.",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_3.parent = thought_2
thought_3.save!
puts "Thought 3 created"

thought_4 = Thought.new(
  title: "Wikipedia with Maps",
  content: "Why not make it possible for anyone to make any type of map. And have
  people add to it later on? A bit like wikipedia and geocities but with maps.
  The map creator can be the admin and can pick and choose what goes onto his map.",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_4.parent = thought_3
thought_4.save!
puts "Thought 4 created"

thought_5 = Thought.new(
  title: "Custom Maps First",
  content: "Would probably start the project with custom maps (languages, music,
  fashion) first before rolling out the map generator itself.",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_5.parent = thought_4
thought_5.save!
puts "Thought 5 created"

thought_6 = Thought.new(
  title: "Jerome Fish App",
  content: "Talked to Jerome about his diving. He has this really cool idea to
  crowdsource the identification of fish in different regions from divers. Users would be
  able to swipe through fish in the region and say if they'd seen them or not.",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_6.parent = thought_4
thought_6.save!
puts "Thought 6 created"

thought_7 = Thought.new(
  title: "mapbox api!",
  content: "mapbox api! Such a cool tool, allows you to put markers and add
  descriptions with the markers. Don't know if you can cover by region. Justin
  used it in his final project and it looks really sleek if instead of covering
  whole countries, you just add a marker with the country flag!",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_7.parent = thought_2
thought_7.save!
puts "Thought 7 created"

thought_8 = Thought.new(
  title: "Dating app for planets",
  content: "Jess' profile was so cool! Why not make a whole app with a bunch of
  planet profiles? Humorous and educational project!",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_8.parent = thought_1
thought_8.save!
puts "Thought 8 created"

thought_9 = Thought.new(
  title: "Custom planets",
  content: "Carol had the genius idea of allowing users to create their own planets!",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_9.parent = thought_8
thought_9.save!
puts "Thought 9 created"

thought_10 = Thought.new(
  title: "Green Iniative Tracker",
  content: "A website to track the green initiatives of all companies. We can scrape the
  info from the SEC website or from their annual reports.",
  user: lucas,
  collection: post_lewagon_collection,
)
thought_10.parent = thought_1
thought_10.save!
puts "Thought 10 created"

puts "All done!"
