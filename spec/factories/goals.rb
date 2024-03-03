FactoryBot.define do
  factory :goal do
    name { 'Test Goal' }
    description { 'Test goal description  ' }
    association :user
    association :team
    format { 'number' }
    start_date { Time.now }
    end_date { Time.now + 1.month }
    initial_value { 0 }
    target_value { 100 }
  end
end
