FactoryBot.define do
  factory :rating do
    value { 4 }
    user
    post
  end
end
