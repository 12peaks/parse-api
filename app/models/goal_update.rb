class GoalUpdate < ApplicationRecord
  belongs_to :goal
  belongs_to :team
  belongs_to :user
end
