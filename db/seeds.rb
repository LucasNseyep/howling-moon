# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Deleting all thoughts"
Thought.delete_all
puts "Deleting all users"
User.delete_all
puts "Deleting all collections"
Collection.delete_all
puts "Deleting all connections"
Connection.delete_all


lucas = User.create!(email: "lucas@howlingmoon.xyz", password:"1234567", username: "Lucas" )

post_lewagon_collection = Collection.create!(title:"Post Le Wagon")

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

deep_work_collection = Collection.create!(title:"Deep Work by Cal Newport")

thought_11 = Thought.new(
  title: "Deep Work take aways",
  content: "It's a book that people keep recommending and that I have read. It's hard to recommend it when my memory is
  as bad as it is. So let's consolidate all my notes",
  user: lucas,
  collection: deep_work_collection,
)
thought_11.save!
puts "Thought 11 created"

thought_12 = Thought.new(
  title: "Distractions",
  content: "It's easy to get distracted in this world of ours. You could spend 98% of your time surfing the web instead
  of doing work or hobbies.",
  user: lucas,
  collection: deep_work_collection,
)
thought_12.parent = thought_11
thought_12.save!
puts "Thought 12 created"


thought_13 = Thought.new(
  title: "There's a solution",
  content: "But it's possible to cut these things out and get your life back. Imaging being able to focus so that you
  won't need to go home and do extra work. Imagine being able to focus for hours at a time and to be efficient in your work.
  That's deep work!",
  user: lucas,
  collection: deep_work_collection,
)
thought_13.parent = thought_12
thought_13.save!
puts "Thought 13 created"

thought_14 = Thought.new(
  title: "The Science of Deep Work",
  content: "Myelin is a layer of fatty tissue that wraps around neurons like an insulator that allows them to activate faster.
  You get better at something the more you fire its specific neural pathway, making its myeling layer grow, making it easier
  to use the pathway as you go along. It's an amazing positive feedback loop.",
  user: lucas,
  collection: deep_work_collection,
)
thought_14.parent = thought_11
thought_14.save!
puts "Thought 14 created"

thought_15 = Thought.new(
  title: "Distractions",
  content: "Therefore if you keep getting distracted and activating other pathways while trying to work, you're not going
  to upskill as quickly as you can.",
  user: lucas,
  collection: deep_work_collection,
)
thought_15.parent = thought_14
thought_15.save!
puts "Thought 15 created"

thought_16 = Thought.new(
  title: "Eudaimonia Machine",
  content: "Turning office space into a Deep Work space because open floor plans are more distracting than anything else.
  Sure they increase communication among workers but they ever noisy and active environment makes it hard to focus.",
  user: lucas,
  collection: deep_work_collection,
)
thought_16.parent = thought_13
thought_16.save!
puts "Thought 16 created"

thought_17 = Thought.new(
  title: "Bimodal Philosophy",
  content: "Split your time into deep work time and shallow work time",
  user: lucas,
  collection: deep_work_collection,
)
thought_17.parent = thought_13
thought_17.save!
puts "Thought 17 created"

thought_18 = Thought.new(
  title: "Systemisation",
  content: "Creative work or any type of work isn't dependent of inspiration but routine and habits. You need to support
  your efforts to go deep. Wake up at the same time everyday. Have a morning routine, etc... So that you can use your energy
  on deep work.",
  user: lucas,
  collection: deep_work_collection,
)
thought_18.parent = thought_17
thought_18.save!
puts "Thought 18 created"

thought_19 = Thought.new(
  title: "Have a buddy",
  content: "Working with someone else or just having someone else working near you can help make you push out insights and
  avoid shallow work.",
  user: lucas,
  collection: deep_work_collection,
)
thought_19.parent = thought_18
thought_19.save!
puts "Thought 18 created"

puts "All done!"
