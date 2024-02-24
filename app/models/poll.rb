class Poll < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true
  belongs_to :team
  has_many :poll_options, dependent: :destroy
  accepts_nested_attributes_for :poll_options, allow_destroy: true
  has_many :poll_votes, through: :poll_options
end
