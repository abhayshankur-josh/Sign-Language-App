class HomeController < ApplicationController
  def index
  end

  def signs
    @signs_view = SignQuery.instance.generate_signs_with_videos
    @signs_view = @signs_view.where("status" => "approved")
  end
end
