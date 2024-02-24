class PollOption < ApplicationRecord
  belongs_to :poll
  has_many :poll_votes, dependent: :destroy
end
