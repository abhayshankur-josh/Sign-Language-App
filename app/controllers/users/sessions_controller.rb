# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # Override the after_sign_in_path_for method
  def after_sign_in_path_for(resource)
    case resource.role_id
    when RoleQuery.instance.get_admin_id
      admins_dashboard_path
    when RoleQuery.instance.get_expert_id
      experts_dashboard_path
    when RoleQuery.instance.get_user_id
      users_path
    else
      root_path
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :not_found and return
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
#
