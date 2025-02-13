class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :init_values, expect: [ :create_user ]
  before_action :proc_params, only: [ :create_user ]

  def dashboard
  end

  def users_tab
  end

  def create_user
    @user = UserQuery.create_user(email: @params.userEmail, full_message: @params.userName, role_name: @params.userRole)
    UserMailer.user_invitation(@user).deliver_now
  rescue StandardError => e
    render json: { error: e.full_message }, status: :expectation_failed
  end

  def videos_tab
  end

  private

  def init_values
    @users = UserQuery.instance.users
    @signs = SignQuery.instance.signs
    @videos = SignQuery.instance.signs
    @submissions = SignQuery.instance.signs
  end

  def proc_params
    @params = params.permit(:userName, :userEmail, :userRole)
  rescue Exception => e
    render json: { error: e.full_message }, status: :expectation_failed
  end
end
