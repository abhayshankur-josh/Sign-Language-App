require 'rails_helper'

RSpec.describe "SubmissionsControllers", type: :request do
  before do
    create(:submission)
    create(:submission)
    create(:submission)
  end

  let(:user) { create(:user, :expert, email: 'test@example.com') }
  let(:valid_token) { JsonWebToken.encode(user_id: user.id, jti_id: user.jti, expiry: (Time.now + 6.hour).to_s) }
  let(:invalid_token) { 'invalid_token' }

  describe "GET /api/v1/submissions" do
    context 'with valid token' do
      before do
        get '/api/v1/submissions', headers: { 'Authorization' => "Bearer #{valid_token}" }
      end

      it 'returns the submissions' do
        puts response.body
        puts Submission.all.to_json
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(Submission.all.to_json)
      end
    end
  end

  describe "POST /api/v1/submissions" do
    context 'with valid token' do
      let(:publisher) { create(:user, :expert, email: Faker::Internet.email) }
      let(:valid_submission_params) do
        {
          publisherEmail: publisher.email,
          videoTitle: Faker::Movie.title,
          videoDescription: Faker::Lorem.paragraph,
          thumbnailFile:  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_video.mp4'), 'video/mp4'),
          videoFile: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_thumbnail.jpg'), 'image/jpg')
        }
      end

      before do
        post '/api/v1/submissions',
          headers: { 'Authorization' => "Bearer #{valid_token}" },
          params: valid_submission_params
      end

      it 'creates the submissions' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Uploaded Successfully")
      end
    end
  end

  describe "GET /api/v1/submissions/view" do
    context 'with valid token' do
      before do
        get '/api/v1/submissions/view', headers: { 'Authorization' => "Bearer #{valid_token}" }
      end

      it 'returns the submissions view' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(SubmissionQuery.instance.get_submissions_view.to_json)
      end
    end
  end

  describe "GET /api/v1/submissions/view/:id" do
    context 'with valid token' do
      let(:randomId) { Submission.pluck(:id).sample }

      before do
        get "/api/v1/submissions/view/#{randomId}",
          headers: { 'Authorization' => "Bearer #{valid_token}" }
      end

      it 'returns the details for :id submissions view ' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(SubmissionQuery.instance.get_submissions_view_for(randomId).to_json)
      end
    end
  end

  describe "POST /api/v1/submissions/status" do
    context 'with valid token' do
      let(:submission) { create(:submission) }
      let(:valid_action_params) do
        {
          submissionId: submission.id,
          approverId: User.pluck(:id).sample,
          signId: submission.sign_id,
          signStatus: :approved,
          rejectionReason: nil
        }
      end

      before do
        post '/api/v1/submissions/status',
          headers: { 'Authorization' => "Bearer #{valid_token}" },
          params: valid_action_params
      end

      it 'updates the status for the submissions' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Submission Action Successfull.")
      end
    end
  end

  describe "GET /api/v1/submissions/activity" do
    context 'with valid token' do
      before do
        get '/api/v1/submissions/activity', headers: { 'Authorization' => "Bearer #{valid_token}" }
      end

      it 'returns the recent activity of user' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["data"]).to eq(SubmissionQuery.instance.get_recent_submission_view_for(user.id))
      end
    end
  end
end
