require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:team) }
    it { is_expected.to have_many(:goal_collaborators).dependent(:destroy) }
    it { is_expected.to have_many(:goal_updates).dependent(:destroy) }
  end
end
