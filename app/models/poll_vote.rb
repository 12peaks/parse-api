class PollVote < ApplicationRecord
  belongs_to :user
  belongs_to :poll_option
  belongs_to :poll
end
