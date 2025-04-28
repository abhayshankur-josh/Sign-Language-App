# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  video_path :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Video, type: :model do
  # before(:each) do
  #   DatabaseCleaner.strategy = :truncation
  #   DatabaseCleaner.clean_with(:truncation)
  # end

  # after(:each) do
  #   DatabaseCleaner.clean
  # end

  # describe 'associations' do
  #   it { should have_one(:sign).dependent(:destroy) }
  #   it { should have_one_attached(:video_clip) }
  #   it { should have_one_attached(:video_thumbnail) }
  # end

  # describe 'validations' do
  #   it { should validate_presence_of(:video_clip) }

  #   it 'is valid with valid attributes' do
  #     video = FactoryBot.build(:video)
  #     expect(video).to be_valid
  #   end

  #   it 'is invalid without video_clip' do
  #     video = FactoryBot.build(:video, video_clip: nil)
  #     expect(video).not_to be_valid
  #     expect(video.errors[:video_clip]).to include("can't be blank")
  #   end

  #   it 'is invalid without video_thumbnail' do
  #     video = FactoryBot.build(:video, video_thumbnail: nil)
  #     expect(video).to be_valid
  #   end
  # end
  context 'associations' do
    it "has one sign" do
      should have_one(:sign).dependent(:destroy)
    end
  end

  context "validations" do
    it "has a valid factory" do
      expect(build(:video)).to be_valid
    end

    it "is invalid without a video_clip" do
      video = build(:video, video_clip: nil)
      expect(video).not_to be_valid
    end

    it "is invalid without a video_path" do
      video = build(:video, video_path: nil)
      expect(video).not_to be_valid
    end
  end
end
