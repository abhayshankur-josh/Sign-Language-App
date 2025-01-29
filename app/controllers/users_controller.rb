class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    p "Current user role id: #{current_user.role_id}"
    if current_user.role_id == 3 
      redirect_to controller: "admins", action: "index"
    end
    @users = user_query_class.get_all_users
  end

  # def create
  #   user_params = {
  #     full_name: params[:full_name],
  #     email: params[:email],
  #     password: params[:password],
  #     role_id: params[:role_id]
  #   }
  #   user_query_class.add_user(user_params)
  #   redirect_to action: :index
  # end

  # def show
  #   # Extract the composite ID value from URL parameters.
  #   id = params.extract_value(:id)
  #   @user = user_query_class.get_user(id)
  # end

  # def edit
  #   # Extract the composite ID value from URL parameters.
  #   id = params.extract_value(:id)
  #   @user = user_query_class.get_user(id)
  # end

  # def new
  # end

  private

  def user_query_class
    @user_query_class ||= UserQuery.new
  end
end
