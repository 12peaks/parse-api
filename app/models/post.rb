class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true
  has_one :team, through: :group

  scope :pinned, -> { where(is_pinned: true) }
end
