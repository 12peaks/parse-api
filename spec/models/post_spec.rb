require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:group).optional }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:reactions).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_many(:mentions).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.pinned' do
      let!(:post_user) { create(:user, :from_omniauth) }
      let!(:pinned_post) { create(:post, is_pinned: true, user: post_user) }
      let!(:unpinned_post) { create(:post, is_pinned: false, user: post_user) }

      it 'includes posts marked as pinned' do
        expect(described_class.pinned).to include(pinned_post)
      end

      it 'excludes posts not marked as pinned' do
        expect(described_class.pinned).not_to include(unpinned_post)
      end
    end
  end
end
