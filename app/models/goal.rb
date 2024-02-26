class Goal < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :goal_collaborators, dependent: :destroy
  has_many :goal_updates, dependent: :destroy
end
