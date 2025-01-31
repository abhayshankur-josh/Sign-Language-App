require_relative "../json_web_token"

class Api::V1::AuthController < Api::V1::ApplicationController
  before_action :authorize_request, except: [ :login, :signup ]
  before_action :login_params
  skip_before_action :verify_authenticity_token

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.valid_password?(params[:password])
      sign_in(:user, @user)
      token = JsonWebToken.encode(user_id: @user.id)
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
    render json: { user: @current_user }, status: :ok
  end



  private

  def login_params
    params.permit(:email, :password)
  end


end
