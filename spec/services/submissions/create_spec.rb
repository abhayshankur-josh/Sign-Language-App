require 'rails_helper'

RSpec.describe Submissions::Create, type: :model do
  # before do
  # create(:role, :learner)
  # create(:video)
  # create(:sign)
  # end

  describe "#call" do
    let(:publisher) { create(:user, :learner) }

    let(:with_thumbnail) do
      {
        publisherEmail: publisher.email,
        videoTitle: "Sample Title",
        videoDescription: "Sample Description",
        videoFile: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_video.mp4'), 'video/mp4'),
        thumbnailFile: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_thumbnail.jpg'), 'image/jpg')
      }
    end

    let(:without_thumbnail) do
      {
        publisherEmail: publisher.email,
        videoTitle: "Sample Title",
        videoDescription: "Sample Description",
        videoFile: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_video.mp4'), 'video/mp4')
      }
    end

    let(:invalid) do
      {
        publisherEmail: publisher.email,
        videoTitle: "Sample Title",
        videoDescription: "Sample Description"
      }
    end

    subject { described_class.new(attributes).call }

    context 'when attributes are valid with thumbnail' do
      let(:attributes) { with_thumbnail }

      it 'creates an submission record successfully' do
        expect { subject }.to change(Submission, :count).by(1)
        result = subject
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Uploaded Successfully")
      end
    end

    context 'when attributes are valid without thumbnail' do
      let(:attributes) { without_thumbnail }

      it 'creates an submission record successfully' do
        expect { subject }.to change(Submission, :count).by(1)
        result = subject
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Uploaded Successfully")
      end
    end

    context 'when attributes are invalid' do
      let(:attributes) { invalid }

      it 'fails to create a submission record' do
        expect { subject }.not_to change(Video, :count)
        expect { subject }.not_to change(Sign, :count)
        expect { subject }.not_to change(Submission, :count)
        result = subject
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Failed to upload Video!")
      end
    end

    context 'when upload_video fails' do
      let(:attributes) { with_thumbnail }

      before do
        allow(VideoQuery.instance).to receive(:create_record).and_return(true)
      end

      it 'raises an exception' do
        expect(subject[:message]).to eq("Failed to upload Video!")
      end
    end

    context 'when create_sign fails' do
      let(:attributes) { with_thumbnail }

      before do
        allow(VideoQuery.instance).to receive(:create_record).and_return(1)
        allow(SignQuery.instance).to receive(:add_sign).and_return(false)
      end

      it 'raises an exception' do
        expect(subject[:message]).to eq("Failed to Create Sign!")
      end
    end

    context 'when get_user fails' do
      let(:attributes) { with_thumbnail }

      before do
        allow(VideoQuery.instance).to receive(:create_record).and_return(1)
        allow(SignQuery.instance).to receive(:add_sign).and_return(1)
        allow(UserQuery.instance).to receive(:get_user_id).and_return(nil)
      end

      it 'raises an exception' do
        expect(subject[:message]).to eq("User not found!")
      end
    end

    context 'when create_submission fails' do
      let(:attributes) { with_thumbnail }

      before do
        allow(VideoQuery.instance).to receive(:create_record).and_return(1)
        allow(SignQuery.instance).to receive(:add_sign).and_return(1)
        allow(UserQuery.instance).to receive(:get_user_id).and_return(1)
        allow(SubmissionQuery.instance).to receive(:add_submission).and_return(nil)
      end

      it 'raises an exception' do
        expect(subject[:message]).to eq("Failed to Create Submission!")
      end
    end
  end
end
