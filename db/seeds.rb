User.destroy_all
Interest.destroy_all
Skill.destroy_all

puts "Start seeds load!"

interests = %w[Sport Music It Art].map do |name|
  Interest.create!(name: name)
end

skills = %w[Ruby Python JavaScript React].map do |name|
  Skill.create!(name: name)
end

2.times do
  User.create!(
    name: Faker::Name.first_name,
    surname: Faker::Name.last_name,
    patronymic: Faker::Name.middle_name,
    email: Faker::Internet.email,
    age: rand(18..65),
    nationality: Faker::Nation.nationality,
    country: Faker::Address.country,
    gender: %w[male female].sample
  )
end

User.all.each do |user|
  user.interests << interests.sample(rand(1..3))
  user.skills << skills.sample(rand(1..3))
end

puts "Seeds loaded!"
