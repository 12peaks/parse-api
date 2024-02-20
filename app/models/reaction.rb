class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  after_create :create_notification

  private

  def create_notification
    if self.post.user != self.user
      Notification.create(
        user: self.user,
        notify_user_id: self.post.user_id,
        status: "unread",
        target_model: "reaction",
        target_model_id: self.id,
        text: "#{self.user.name} reacted to your post",
        post_id: self.post_id,
        group_id: self.post.group_id,
        image_url: self.emoji_text
      )
    end
  end
end
