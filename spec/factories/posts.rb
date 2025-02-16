FactoryBot.define do
  factory :post do
    title { "MyTitle" }
    body { "MyText" }
    ip { "111.111.11" }
    user
  end
end
