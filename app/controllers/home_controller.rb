class HomeController < ApplicationController
  def index
  end

  def signs
    @signs_view = SignQuery.instance.generate_signs_with_videos
    @signs_view = @signs_view.where("status" => "approved")
  end

  def redirect_to_external
    sign_out(current_user)
    redirect_to "http://localhost:5173", allow_other_host: true
  end
end
