class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :post
  belongs_to :notify_user, class_name: 'User', foreign_key: 'notify_user_id'

  scope :for_notify_user, ->(user_id) { where(notify_user_id: user_id) }
end
