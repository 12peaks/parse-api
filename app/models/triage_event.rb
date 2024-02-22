class TriageEvent < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :team
  has_many :triage_event_comments
  has_many_attached :attachments

  def attachments_data
    attachments.map do |attachment|
      {
        url: Rails.application.routes.url_helpers.url_for(attachment),
        name: attachment.filename.to_s,
        id: attachment.id
      }
    end
  end
end
