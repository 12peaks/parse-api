FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph }
    text_content { Faker::Lorem.paragraph }
    is_pinned { false }
    group { nil }
    user
  end
end
