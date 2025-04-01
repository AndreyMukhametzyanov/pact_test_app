FactoryBot.define do
  factory :user do
    surname { "Doe" }
    name { "John" }
    patronymic { "Michael" }
    email { Faker::Internet.unique.email }
    age { 30 }
    nationality { "American" }
    country { "USA" }
    gender { "male" }
    interests { [ FactoryBot.create(:interest, name: "Reading"), FactoryBot.create(:interest, name: "Hiking") ] }
    skills { [ FactoryBot.create(:skill, name: "Ruby"), FactoryBot.create(:skill, name: "Rails") ] }
  end
end
