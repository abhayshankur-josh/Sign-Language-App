class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :init_values, expect: [ :create_user ]
  before_action :proc_params, only: [ :create_user ]

  def dashboard
  end

  def users_tab
  end

  def create_user
    begin
      email = @params[:userEmail]
      full_name = @params[:userName]
      role_name = @params[:userRole]
      ActiveRecord::Base.transaction do
        @user = UserQuery.instance.create_user(email, full_name, role_name)
        UserMailer.user_invitation(@user).deliver_now
        flash[:message] = "Your message has been sent successfully."
      end
    rescue StandardError => e
      flash[:message] = "#{e.full_message}"
    end
    redirect_to admins_users_path
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
    @params = params.permit(:authenticity_token, :userName, :userEmail, :userRole)
  rescue Exception => e
    render json: { error: e.full_message }, status: :expectation_failed
  end
end
