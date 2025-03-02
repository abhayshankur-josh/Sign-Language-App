require_relative "../json_web_token"

class Api::V1::AuthController < Api::V1::ApplicationController
  before_action :authorize_request, only: [ :signout, :profile ]
  before_action :login_params, only: :login
  before_action :signup_params, only: :signup
  before_action :refresh_jti, only: :signout

  # POST /auth/login
  def login
    ActiveRecord::Base.transaction do
      user = User.find_by_email(params[:email])
      if user&.valid_password?(params[:password])
        token = generate_token(user)
        # time = Time.now + 24.hours.to_i
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
    # ActiveRecord::Base.transaction do
    #   user = User.new
    #   user.full_name = params[:username]
    #   user.email = params[:email]
    #   user.password = params[:password]
    #   user.password_confirmation = params[:confirm_password]
    #   user.role_id = 2
    #   if user.valid? && user.save
    #     # user.save!
    #     token = generate_token(user)
    #     time = Time.now + 24.hours.to_i
    #     render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
    #                   username: user.full_name }, status: :created
    #   else
    #     render json: { error: "User Details Invalid: #{user.errors.full_messages}" }, status: :bad_request
    #   end
    # end
    ActiveRecord::Base.transaction do
      expert = Experts::Create.new(signup_params)
      result = expert.create
      if result[:success]
        token = generate_token(result[:message])
        render json: { message: "Expert Created Successfully.", token: token }, status: :created
      else
        render json: { message: result[:message] }, status: :ok
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
    render json: { errors: "Ooppszz.. Something went wrong!" }, status: :bad_request
  end

  # GET /auth/profile
  def profile
    render json: @current_user, status: :ok
  rescue Exception => e
    render json: { error: "Ooppszz.. Something went wrong!" }, status: :expectation_failed
  end

  private

  def login_params
    params.permit(:email, :password)
  rescue Exception => e
    render json: { errors: "Ooppszz.. Something went wrong!" }, status: :bad_request
  end

  def signup_params
    params.permit(:username, :email, :password, :confirm_password)
  rescue Exception => e
    render json: { errors: "Ooppszz.. Something went wrong!" }, status: :bad_request
  end

  def refresh_jti
    @user = User.find(@current_user[:id])
    @user.jti = SecureRandom.uuid
    @user.save!
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.message }, status: :unauthorized
  end

  def generate_token(user)
    sign_in(:user, user)
    user.jti = SecureRandom.uuid
    user.save!
    exp = Time.now + 6.hours.to_i
    JsonWebToken.encode({
      user_id: user.id,
      jti_id: user.jti,
      expiry: exp.to_s
    })
  end
end
