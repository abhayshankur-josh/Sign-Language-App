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
  validate :video_path, presence: true
  belongs_to :sign
end
