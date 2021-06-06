FactoryBot.define do
  factory :inquiry do
    size { 5 }
    office_type { 1 }
    company { "Company" }
    peers { true }
    email { "mrfake@fake.com" }
    flexible { true }
    start_date {'2021-06-16'}
    phone { 0707123456 }
  end
end