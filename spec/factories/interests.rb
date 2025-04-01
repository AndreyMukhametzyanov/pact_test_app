FactoryBot.define do
  factory :interest do
    name { Faker::Hobby.unique.activity }
  end
end
