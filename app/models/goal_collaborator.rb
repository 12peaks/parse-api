class GoalCollaborator < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :goal
end
