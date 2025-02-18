FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "email#{n}@test.com" }
  end
end
