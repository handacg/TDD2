50.times do
  User.create(first_name: Faker::Artist.name, last_name: Faker::Pokemon.name, email: Faker::Internet.email, password: "thp123")
end