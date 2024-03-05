FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { 'Test User' }
    password { 'password' }
    trait :from_omniauth do
      provider { 'google_oauth2' }
      uid { '123545' }
      avatar_url { 'http://placekitten.com/200/300' }
      after(:build) do |user, _evaluator|
        user.skip_confirmation!
      end
    end
    after(:build) do |user, _evaluator|
      user.skip_confirmation!
    end
  end
end
