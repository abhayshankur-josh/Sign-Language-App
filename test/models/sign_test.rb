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
require "test_helper"

class SignTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
