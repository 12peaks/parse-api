class Team < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :groups, dependent: :destroy
end