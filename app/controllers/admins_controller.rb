class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :init_values

  def dashboard
  end

  def users_tab
  end

  def videos_tab
  end

  def add_user_tab
  end

  private

  def init_values
    @users = UserQuery.instance.users
    @signs = SignQuery.instance.signs
    @videos = SignQuery.instance.signs
    @submissions = SignQuery.instance.signs
  end
end
