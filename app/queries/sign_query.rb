class SignQuery
  attr_reader :signs

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @signs = Sign.all
  end

  def add_sign(title, description, video_clip, video_thumbnail = nil)
    ActiveRecord::Base.transaction do
      # Create a Video Record.
      video = VideoQuery.instance.create_record(video_clip, video_thumbnail)

      # Create a Sign Record.
      sign = Sign.new
      sign.title = title
      sign.description = description
      sign.status = "pending"
      sign.video_id = video.id
      sign.save!
    end
  end

  private_class_method :new
end
