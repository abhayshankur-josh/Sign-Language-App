class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = user_query_class.get_all_users
  end

  private

  # def user_query_class
  #   @user_query_class ||= UserQuery.new
  # end
end
