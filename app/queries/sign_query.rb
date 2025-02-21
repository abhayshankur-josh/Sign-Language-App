class SignQuery
  attr_reader :signs

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @signs = Sign.all
  end

  def add_sign(title, description, videoId)
    # Create a Sign Record.
    sign = Sign.new
    sign.title = title
    sign.description = description
    sign.status = "pending"
    sign.video_id = videoId
    sign.save!
    sign.id
  rescue Exception => e
    Rails.logger.error "LOG WARNING: #{e.full_message}"
  end

  def generate_signs_with_videos
    @signs.joins(:video).select("signs.id, signs.title, signs.description, signs.status, videos.*")
  rescue Exception => e
    Rails.logger.error "LOG WARNING: SQL ERROR - #{e.full_message}"
  end

  private_class_method :new
end
