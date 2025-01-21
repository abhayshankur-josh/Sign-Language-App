class Video < ApplicationRecord
  validate :video_path, presence: true
  belongs_to :sign
end
