FactoryBot.define do
  factory :inquiry do
    size { 1 }
    type { false }
    company { "MyString" }
    peers { false }
    email { "MyString" }
    location { "" }
    date { "2021-06-05" }
    flexible { false }
    phone { 1 }
  end
end
