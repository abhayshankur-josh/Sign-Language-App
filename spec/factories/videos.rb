# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  video_path :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :video do
    video_clip { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_video.mp4'), 'video/mp4') }
    video_thumbnail { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_thumbnail.jpg'), 'image/jpg') }
  end
end
