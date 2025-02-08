class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  USER_ROLE_ID = 1
  EXPERT_ROLE_ID = 2
  ADMIN_ROLE_ID = 3

  def page_not_found
    raise ActionController::RoutingError.new("Not Found")
  rescue
    render_404
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
end
