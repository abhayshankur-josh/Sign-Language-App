class AdminsController < ApplicationController
  include AdminsHelper

  # Remove auth except when api is ready.
  before_action :authenticate_user!, except: :card_details
  before_action :init_values, only: [ :dashboard, :users_tab, :videos_tab ]
  before_action :proc_params, only: [ :create_user ]
  before_action :upload_params, only: [ :form_videos ]

  # GET : /admins/dashboard
  def dashboard
  end

  # GET : /admins/users
  def users_tab
  end

  # POST : /admins/user
  def create_user
    begin
      email = @user_params[:userEmail]
      full_name = @user_params[:userName]
      role_name = @user_params[:userRole]
      ActiveRecord::Base.transaction do
        @user = UserQuery.instance.create_user(email, full_name, role_name)
        UserMailer.user_invitation(@user).deliver_now
        flash[:success] = "Mail has been sent successfully."
      end
    rescue StandardError => e
      flash[:error] = "#{e.full_message}"
    end
    redirect_to admins_users_path
  end

  def update_user
    user_params = {
      id: update_user_params[:userId].to_i,
      full_name: update_user_params[:userName],
      email: update_user_params[:userEmail],
      role_id: RoleQuery.instance.get_role_id(update_user_params[:userRole])
    }
    if UserQuery.instance.update_user?(user_params)
      flash[:notice] = "User updated successfully."
    else
      flash[:notice] = "Error updating user."
    end
    redirect_to admins_dashboard_path
  end

  def deactivate_user
    id = params[:id]
    if UserQuery.instance.deactivate_user?(id)
      flash[:notice] = "User deactivated successfully."
    else
      flash[:alert] = "Error deactivating user."
    end
    redirect_to admins_dashboard_path
  end

  # GET : /admins/videos
  def videos_tab
    @signs_view = SignQuery.instance.generate_signs_with_videos
  end

  # POST : /admins/video
  def form_videos
    # TODO Create service
    ActiveRecord::Base.transaction do
      videoId = VideoQuery.instance.create_record(@video_params[:videoFile], @video_params[:thumbnailFile])
      signId = SignQuery.instance.add_sign(@video_params[:videoTitle], @video_params[:videoDescription], videoId)
      publisherId = UserQuery.instance.get_user_id(@video_params[:publisherEmail])
      submissionId = SubmissionQuery.instance.add_submission(publisherId, signId)
      if submissionId
        flash[:success] = "Uploaded Successfully"
        Rails.logger.info "Uploaded Successfully"
      else
        flash[:warning] = "Upload failed."
        Rails.logger.info "Upload failed."
      end
    end
    redirect_to admins_videos_path
  rescue Exception => e
    Rails.logger.error "ERROR: #{e.full_message}"
  end

  # GET : /admins/video/:sign
  def card_details
    # @signs_view = SignQuery.instance.generate_signs_with_videos
    # data = @signs_view.find_by(id= params[:sign])
    data = SignQuery.instance.get_sign_details(params[:sign])
    render json: data
  end

  # GET : /admins/signs
  def signs_tab
    respond_to do |format|
      format.html
      format.json { render json: SignDatatable.new(params) }
    end
  end

  # GET : /admins/submissions
  def submissions_tab
    @current_email = current_user.email
    respond_to do |format|
      format.html
      format.json { render json: SubmissionDatatable.new(params) }
    end
  end

  private

  def init_values
    @users = UserQuery.instance.users
    @signs = SignQuery.instance.signs
    @videos = VideoQuery.instance.videos
    @submissions = SubmissionQuery.instance.submissions
  end

  def proc_params
    @user_params = params.permit(:authenticity_token, :userName, :userEmail, :userRole)
  rescue Exception => e
    render json: { error: e.full_message }, status: :expectation_failed
  end

  def upload_params
    @video_params = params.permit(:videoFile, :thumbnailFile, :videoTitle, :videoDescription, :publisherEmail)
  rescue Exception => e
    render json: { error: e.full_message }, status: :expectation_failed
  end

  def update_user_params
    params.permit(:userId, :userName, :userEmail, :userRole)
  end
end
