FactoryBot.define do
  factory :group do
    name { 'Test Group ' }
    description { 'Group for testing things' }
    association :team
  end
end
