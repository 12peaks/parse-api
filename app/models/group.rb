class Group < ApplicationRecord
  belongs_to :team
  has_one_attached :avatar
  has_one_attached :cover_image
  has_many :posts
  has_many :notifications
  has_many :group_users, dependent: :delete_all
  has_many :users, through: :group_users


  before_create :generate_url_slug

  def avatar_url
    Rails.application.routes.url_helpers.url_for(avatar) if avatar.attached?
  end

  def cover_image_url
    Rails.application.routes.url_helpers.url_for(cover_image) if cover_image.attached?
  end

  private

  def generate_url_slug
    self.url_slug = name.parameterize
  end
end
