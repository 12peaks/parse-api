class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true
  has_one :team, through: :group
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :mentions, dependent: :destroy

  scope :pinned, -> { where(is_pinned: true) }
end
