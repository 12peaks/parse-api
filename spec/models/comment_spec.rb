require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:mentions).dependent(:destroy) }
  end

  describe 'callbacks' do
    describe 'after_create' do
      let(:post_owner) { create(:user, :from_omniauth) }
      let(:commenter) { create(:user, :from_omniauth, email: 'commenter@test.com') }
      let(:post) { create(:post, user: post_owner) }
      let(:comment) { build(:comment, user: commenter, post:) }

      context 'when the commenter is not the post owner' do
        it 'generates a notification for the post owner' do
          expect { comment.save }.to change(Notification, :count).by(1)
          notification = Notification.last

          aggregate_failures do
            expect(notification.user).to eq(commenter)
            expect(notification.notify_user_id).to eq(post_owner.id)
            expect(notification.status).to eq('unread')
            expect(notification.target_model).to eq('comment')
            expect(notification.target_model_id).to eq(comment.id)
            expect(notification.text).to eq("#{commenter.name} commented on your post")
            expect(notification.post_id).to eq(post.id)
            expect(notification.group_id).to eq(post.group_id)
            expect(notification.image_url).to eq(commenter.avatar_image_url)
          end
        end
      end

      context 'when the commenter is the post owner' do
        let(:comment_by_owner) { build(:comment, user: post_owner, post:) }

        it 'does not generate a notification' do
          expect { comment_by_owner.save }.not_to change(Notification, :count)
        end
      end
    end
  end
end
