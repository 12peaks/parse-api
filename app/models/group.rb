class Group < ApplicationRecord
  belongs_to :team
  has_one_attached :avatar
  has_one_attached :cover_image
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
