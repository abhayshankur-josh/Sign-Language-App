class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    User.create!({
      full_name: params[:full_name],
      email: params[:email],
      password: params[:password],
      role_id: params[:role_id]
    })
    # redirect_to users
  end

  def show
    # Extract the composite ID value from URL parameters.
    id = params.extract_value(:id)
    @user = User.find(id).first
  end

  def new
  end
end
