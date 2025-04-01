FactoryBot.define do
  factory :skill do
    name { Faker::ProgrammingLanguage.unique.name }
  end
end
