FactoryBot.define do
  factory :inquiry do
    size { 1 }
    type { false }
    sequence(:company) { |n| "Company#{n}" }
    peers { false }
    sequence(:email) { |n| "mrfake#{n}@fake.com" }
    date { "2021-06-05" }
    flexible { false }
    phone { 0707123456 }
  end
end
