class TriageEventComment < ApplicationRecord
  belongs_to :triage_event
  belongs_to :user
end
