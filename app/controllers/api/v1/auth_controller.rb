
class Api::V1::AuthController < Api::V1::ApplicationController
  before_action :authorize_request, only: :profile
  before_action :login_params, only: :login
  before_action :signup_params, only: :signup
  before_action :authorize_request_for_logout, only: :signout
  before_action :refresh_jti, only: :signout

  # POST /auth/login
  def login
    ActiveRecord::Base.transaction do
      user = User.find_by_email(login_params[:email])
      if user&.valid_password?(login_params[:password])
        token = generate_token(user)
        render json: { token: token, message: "Login Successfully." }, status: :created
      else
        render json: { error: "unauthorized" }, status: :unauthorized
      end
    end
  rescue Exception => e
    render json: { error: "ERROR: #{e.full_message}" }, status: :expectation_failed
  end

  # POST /auth/signup
  def signup
    ActiveRecord::Base.transaction do
      expert = Experts::Create.new(signup_params)
      result = expert.create
      if result[:success]
        token = generate_token(result[:message])
        render json: { message: "Expert Created Successfully.", token: token }, status: :created
      else
        render json: { error: result[:message] }, status: :expectation_failed
      end
    end
  rescue Exception => e
    Rails.logger.error e.full_message
    render json: { error: e.message }, status: :expectation_failed
  end

  # DELETE /auth/signout
  def signout
    sign_out @current_user
    render json: { message: "Sign out successful." }, status: :ok
  rescue Exception => e
    render json: { error: "Ooppszz.. Something went wrong!" }, status: :bad_request
  end

  # GET /auth/profile
  def profile
    profile = { "id": @current_user.id,
      "username": @current_user.full_name,
      "email": @current_user[:email],
      "role": RoleQuery.instance.get_role_name(@current_user.role_id)
    }
    render json: profile, status: :ok
  rescue Exception => e
    render json: { error: "Ooppszz.. Something went wrong!" }, status: :expectation_failed
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def signup_params
    params.permit(:username, :email, :password, :confirm_password)
  rescue Exception => e
    render json: { error: "Ooppszz.. Something went wrong!" }, status: :bad_request
  end

  def refresh_jti
    @user = User.find(@current_user[:id])
    @user.update_column(:jti, SecureRandom.uuid)
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unauthorized
  end

  def generate_token(user)
    sign_in(:user, user)
    user.update_column(:jti, SecureRandom.uuid)
    exp = Time.now + 6.hours.to_i
    JsonWebToken.encode({
      user_id: user.id,
      jti_id: user.jti,
      expiry: exp.to_s
    })
  end
end
