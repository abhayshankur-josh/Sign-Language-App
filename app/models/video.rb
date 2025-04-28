# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  video_path :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Video < ApplicationRecord
  has_one_attached :video_clip
  has_one_attached :video_thumbnail

  validates :video_clip, presence: true
  validates :video_path, presence: true

  has_one :sign, dependent: :destroy
end
