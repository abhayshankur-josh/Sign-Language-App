require 'rails_helper'
require_relative '../../app/controllers/api/json_web_token.rb'

RSpec.describe "AuthControllers", type: :request do
  let(:user) { create(:user, :expert, email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:valid_token) { JsonWebToken.encode(user_id: user.id, jti_id: user.jti, expiry: (Time.now + 6.hour).to_s) }
  let(:valid_login_params) { { email: user.email, password: 'password123' } }
  let(:invalid_login_params) { { email: user.email, password: 'wrongpassword' } }
  let(:valid_signup_params) {
    {
      username: 'newuser',
      email: 'newuser@example.com',
      password: 'password123',
      confirm_password: 'password123'
    }
  }
  let(:invalid_signup_params) {
    {
      username: 'newuser',
      email: 'invalidemail',
      password: 'password123',
      confirm_password: 'different_password'
    }
  }

  describe 'POST /api/v1/auth/signup' do
    # Stub the Experts::Create service to avoid dealing with its implementation details
    let(:expert_service) { instance_double('Experts::Create') }

    context 'with valid parameters' do
      before do
        allow(Experts::Create).to receive(:new).and_return(expert_service)
        allow(expert_service).to receive(:create).and_return({ success: true, message: user })

        post '/api/v1/auth/signup', params: valid_signup_params
      end

      it 'creates a new expert and returns a token' do
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('token', 'message')
        expect(json_response['message']).to eq('Expert Created Successfully.')
      end
    end

    context 'with invalid parameters' do
      before do
        allow(Experts::Create).to receive(:new).and_return(expert_service)
        allow(expert_service).to receive(:create).and_return({ success: false, message: 'Validation failed' })

        post '/api/v1/auth/signup', params: invalid_signup_params
      end

      it 'returns validation errors' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Validation failed')
      end
    end

    context 'when an exception occurs' do
      before do
        allow(Experts::Create).to receive(:new).and_return(expert_service)
        allow(expert_service).to receive(:create).and_raise(StandardError.new('An error occurred'))

        post '/api/v1/auth/signup', params: valid_signup_params
      end

      it 'returns an error status and message' do
        expect(response).to have_http_status(:expectation_failed)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('error')
      end
    end
  end

  describe 'POST /api/v1/auth/login' do
    context 'with valid credentials' do
      before do
        post '/api/v1/auth/login', params: valid_login_params
      end

      it 'returns a token and success message' do
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('token', 'message')
        expect(json_response['message']).to eq('Login Successfully.')
      end
    end

    context 'with invalid credentials' do
      before do
        post '/api/v1/auth/login', params: invalid_login_params
      end

      it 'returns an unauthorized status with error message' do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('unauthorized')
      end
    end
  end

  describe 'GET /api/v1/auth/profile' do
    context 'with valid token' do
      before do
        get '/api/v1/auth/profile', headers: { 'Authorization' => "Bearer #{valid_token}" }
      end

      it 'returns the user profile' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(user.id)
        expect(json_response['email']).to eq(user.email)
      end
    end

    context 'with invalid token' do
      before do
        get '/api/v1/auth/profile', headers: { 'Authorization' => "Bearer invalid_token" }
      end

      it 'returns an error status' do
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Provide Authorization value.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without token' do
      before do
        get '/api/v1/auth/profile'
      end

      it 'returns unauthorized status' do
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Provide Authorization value.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/auth/signout" do
    context "with valid token" do
      before do
        # Stub the sign_out method which is likely from Devise
        allow_any_instance_of(Api::V1::AuthController).to receive(:sign_out).and_return(true)

        delete '/api/v1/auth/signout', headers: { 'Authorization' => "Bearer #{valid_token}" }
      end

      it 'signs out the user and invalidates the token' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Sign out successful.')

        # Verify that the JTI was refreshed (token invalidated)
        expect(user.reload.jti).not_to eq(JsonWebToken.decode(valid_token)[:jti_id])
      end
    end

    context 'with invalid token' do
      before do
        delete '/api/v1/auth/signout', headers: { 'Authorization' => "Bearer invalid_token" }
      end

      it 'returns an error status' do
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(json_response["error"]).to eq("Provide Authorization value.")
      end
    end

    context 'without token' do
      before do
        delete '/api/v1/auth/signout'
      end

      it 'returns unauthorized status' do
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(json_response["error"]).to eq("Provide Authorization value.")
      end
    end
  end
end
