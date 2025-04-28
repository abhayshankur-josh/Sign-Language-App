class VideoQuery
  attr_reader :videos
  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @videos ||= Video.all
  end

  def upload_video(clip, thumbnail = nil)
    video = Video.new
    # Attach the video clip
    video.video_clip.attach(clip)
    # Attach the thumbnail if it's present
    video.video_thumbnail.attach(thumbnail) if thumbnail.present?
    # Save the video after attaching files
    video.video_path = video.video_clip.name
    video.save!
    video
  rescue Exception => e
    Rails.logger.warn "LOG WARNING: #{e.full_message}"
  end

  def create_record(clip, thumbnail = nil)
    video = upload_video(clip, thumbnail)
    video.update!(video_path: Rails.application.routes.url_helpers.rails_blob_path(video.video_clip, only_path: true))
    video.id
  rescue Exception => e
    Rails.logger.warn "LOG WARNING: #{e.full_message}"
  end

  private_class_method :new
end
