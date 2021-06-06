FactoryBot.define do
  factory :inquiry do
    size { 1 }
    variants { 1 }
    sequence(:company) { |n| "Company#{n}" }
    peers { true }
    sequence(:email) { |n| "mrfake#{n}@fake.com" }
    flexible { true }
    start_date {''}
    phone { 0707123456 }
  end
end
