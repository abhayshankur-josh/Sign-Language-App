require_relative "../json_web_token"

class Api::V1::AuthController < Api::V1::ApplicationController
  before_action :authorize_request, except: [ :login, :signup ]
  before_action :login_params
  before_action :refresh_jti, only: :signout
  # skip_before_action :verify_authenticity_token

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.valid_password?(params[:password])
      sign_in(:user, @user)
      jti_id = SecureRandom.uuid
      @user.jti = jti_id
      @user.save!
      token = JsonWebToken.encode({ user_id: @user.id, jti_id: jti_id })
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: @user.full_name }, status: :ok
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  # POST /auth/signup
  def signup
  end

  # DELETE /auth/signout
  def signout
    sign_out @current_user
    render json: { message: "Sign out successful." }, status: :ok
  rescue Exception => e
    render json: { errors: "Ooppszz.. Something went wrong!" }, status: :bad_request
  end



  private

  def login_params
    params.permit(:email, :password)
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
end
