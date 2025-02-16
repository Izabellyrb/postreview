FactoryBot.define do
  factory :post do
    title { "MyTitle" }
    body { "MyText" }
    ip { "111.11.1.1" }
    user
  end
end
