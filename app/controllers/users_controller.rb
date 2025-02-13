class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = user_query_class.users
  end

  private

  def user_query_class
    @user_query_class ||= UserQuery.instance
  end
end
