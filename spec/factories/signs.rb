# == Schema Information
#
# Table name: signs
#
#  id          :integer          not null, primary key
#  description :text
#  status      :integer
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
# spec/factories/signs.rb
FactoryBot.define do
  factory :sign do
    title { 'Sample Title' }
    description { 'Sample Description' }
    status { 'pending' }
    video
  end
end
