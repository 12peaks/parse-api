class Team < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :groups, dependent: :destroy
  has_many :posts, through: :users
  has_many :triage_events
  has_many :polls
  has_many :goals
end
