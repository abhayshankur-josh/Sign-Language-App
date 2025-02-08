class AdminsController < ApplicationController
  before_action :authenticate_user!

  # GET /admins or /admins.json
  def index
    @users = MasterUserQuery.instance.get_all_users
  end
end
