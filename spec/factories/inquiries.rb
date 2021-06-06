FactoryBot.define do
  factory :inquiry do
    size { 1 }
    variants { true }
    sequence(:company) { |n| "Company#{n}" }
    peers { true }
    sequence(:email) { |n| "mrfake#{n}@fake.com" }
    flexible { true }
    phone { 0707123456 }
  end
end
