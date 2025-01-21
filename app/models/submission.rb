class Submission < ApplicationRecord
  validates :sign_id, :submitted_by, :approved_by, presence: true
  has_many :user
  has_many :sign
end
