# == Schema Information
#
# Table name: signs
#
#  id          :integer          not null, primary key
#  description :text
#  status      :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_id    :integer
#
# Indexes
#
#  index_signs_on_video_id  (video_id)
#
# Foreign Keys
#
#  video_id  (video_id => videos.id)
#
class Sign < ApplicationRecord
  enum :status, [ :approved, :pending, :rejected ]
  validates :title, :description, :video_id, presence: true
  validates :status, inclusion: { in: :status, message: "%{value} is not valid status!" }
  belongs_to :video
end
