FactoryBot.define do
  factory :inquiry do
    size { 1 }
    type { true }
    sequence(:company) { |n| "Company#{n}" }
    peers { true }
    sequence(:email) { |n| "mrfake#{n}@fake.com" }
    date { '2021-06-05' }
    flexible { true }
    phone { 0o707123456 }
  end
end
