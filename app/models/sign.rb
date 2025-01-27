class Sign < ApplicationRecord
  enum :status, [ :approved, :pending, :rejected ]
  validates :title, :description, :video_id, presence: true
  validates :status, inclusion: { in: :status, message: "%{value} is not valid status!" }
  has_one :video
end
