class HomeController < ApplicationController
  def index
    case current_user.try(&:role_id)
    when ADMIN_ROLE_ID
        redirect_to controller: "admins", action: "index"

    when EXPERT_ROLE_ID
        # redirect_to controller: "admins", action: "index"
        page_not_found

    when USER_ROLE_ID
        redirect_to controller: "users", action: "index"

    else


    end
  end
end
