class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validate :user_must_belong_to_team_of_group

  private

  def user_must_belong_to_team_of_group
    unless group.team.users.include?(user)
      errors.add(:user, "must belong to the team of the group")
    end
  end
end
