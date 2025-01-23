class UsersController < ApplicationController
  def index
    @users = user_query_class.get_all_users
  end

  def create
    user_params = {
      full_name: params[:full_name],
      email: params[:email],
      password: params[:password],
      role_id: params[:role_id]
    }
    user_query_class.add_user(user_params)
  end

  def show
    # Extract the composite ID value from URL parameters.
    id = params.extract_value(:id)
    @user = user_query_class.get_user(id)
  end

  def edit
    # Extract the composite ID value from URL parameters.
    id = params.extract_value(:id)
    @user = user_query_class.get_user(id)
  end

  def new
  end

  def user_query_class
    @user_query_class ||= UserQuery.new
  end
end
