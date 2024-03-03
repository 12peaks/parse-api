class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :mentions, dependent: :destroy

  after_create :generate_notification

  private

  def generate_notification
    return unless post.user != user

    Notification.create(
      user:,
      notify_user_id: post.user_id,
      status: 'unread',
      target_model: 'comment',
      target_model_id: id,
      text: "#{user.name} commented on your post",
      post_id: post.id,
      group_id: post.group_id,
      image_url: user.avatar_image_url
    )
  end
end
