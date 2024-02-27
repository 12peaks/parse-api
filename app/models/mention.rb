class Mention < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :group
  belongs_to :comment

  after_create :send_mention_notification

  private

  def send_mention_notification
    Notification.create(
      user: self.user,
      notify_user_id: self.mentioned_user_id,
      status: "unread",
      target_model: "mention",
      target_model_id: self.id,
      text: "#{self.user.name} mentioned you in a #{self.comment.present? ? 'comment' : 'post'}.",
      post_id: self.post.id,
      group_id: self.group.id,
      image_url: self.user.avatar_image_url,
    )
  end
end
