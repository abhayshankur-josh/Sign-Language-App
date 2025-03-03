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
require 'rails_helper'

RSpec.describe Sign, type: :model do
  let(:video) { create(:video) }
  let(:sign) { build(:sign, video: video) }

  describe 'associations' do
    it { should belong_to(:video) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:video_id) }

    it 'validates inclusion of status in status enum' do
      should define_enum_for(:status).with_values([ :approved, :pending, :rejected ])
      should validate_inclusion_of(:status).in_array(Sign.statuses.keys)
    end

    it 'is valid with valid attributes' do
      expect(sign).to be_valid
    end

    it 'is invalid without a title' do
      sign.title = nil
      expect(sign).not_to be_valid
      expect(sign.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a description' do
      sign.description = nil
      expect(sign).not_to be_valid
      expect(sign.errors[:description]).to include("can't be blank")
    end

    it 'is invalid without a video_id' do
      sign.video_id = nil
      expect(sign).not_to be_valid
      expect(sign.errors[:video_id]).to include("can't be blank")
    end
  end
end
