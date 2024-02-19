class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_create :generate_notification

  private

  def generate_notification
    if self.post.user != self.user
      Notification.create(
        user: self.user,
        notify_user_id: self.post.user_id,
        status: "unread",
        target_model: "comment",
        target_model_id: self.id,
        text: "#{self.user.name} commented on your post",
        post_id: self.post.id,
        group_id: self.post.group_id,
        image_url: self.user.avatar_url
      )
    end
  end
end
