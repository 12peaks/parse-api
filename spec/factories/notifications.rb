FactoryBot.define do
  factory :notification do
    association :notify_user, factory: :user
    status { 'unread' }
    text { 'This is a notification' }
    image_url { 'https://example.com/image.jpg' }
    target_model { 'post' }
    target_model_id { '1c8b3967-e5ba-4858-a475-da4b4301faf5' }
    user factory: :user
    group { nil }
    post { nil }
    notify_user_id { notify_user.id }
  end
end
