require 'rails_helper'
require_relative '../../app/controllers/api/json_web_token.rb'

RSpec.describe "ApplicationControllers", type: :request do
  # describe "GET /application_controllers" do
  #   it "works! (now write some real specs)" do
  #     get application_controllers_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

  let(:user) { create(:user, :expert, id: 1) }
  let(:valid_token) do
    JsonWebToken.encode(user_id: user.id, jti_id: user.jti, expiry: (Time.now + 6.hour).to_s)
  end
  let(:expired_token) do
    JsonWebToken.encode(user_id: user.id, jti_id: user.jti, expiry: (Time.now - 6.hour).to_s)
  end
  let(:invalid_token) { "invalid.token.string" }
  let(:revoked_token) do
    # Create a token with a user_id that exists but a jti that doesn't match
    old_jti_value = user.jti.to_s
    user.update_column(:jti, SecureRandom.uuid) # Change the JTI to simulate revocation
    JsonWebToken.encode(user_id: user.id, jti_id: old_jti_value, expiry: (Time.now + 6.hour).to_s)
  end

  describe "GET /api/v1/not_found" do
    context 'with valid authorization' do
      before do
        get '/api/v1/not_found', headers: { 'Authorization' => "Bearer #{valid_token}" }
      end

      it 'returns a not_found message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'not_found' })
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with expired token' do
      before do
        get '/api/v1/not_found', headers: { 'Authorization' => "Bearer #{expired_token}" }
      end

      it 'returns an unauthorized status with appropriate error message' do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Token has expired!' })
      end
    end

    context 'with invalid token' do
      before do
        get '/api/v1/not_found', headers: { 'Authorization' => "Bearer #{invalid_token}" }
      end

      it 'returns a precondition_failed status with JWT decode error' do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to include('Provide Authorization value.')
        # The exact error message will depend on the JWT gem but will contain something about invalid token
      end
    end

    context 'with revoked token' do
      before do
        get '/api/v1/not_found', headers: { 'Authorization' => "Bearer #{revoked_token}" }
      end

      it 'returns an unauthorized status with token revoked message' do
        # byebug

        expect(JSON.parse(response.body)).to eq({ 'error' => 'Token has been revoked!' })
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without authorization header' do
      before do
        get '/api/v1/not_found'
      end

      it 'returns an unauthorized status with appropriate error message' do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Provide Authorization value.' })
      end
    end
  end
end
