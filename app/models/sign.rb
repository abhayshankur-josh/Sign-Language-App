class Sign < ApplicationRecord
  validates :title, :description, :video_id, presence: true
  validates :status, inclusion: { in: %w[approved pending rejected], message: "%{value} is not valid status!" }
  has_one :video
end
