class VideoQuery
  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @users ||= Video.all
  end

  def upload_video(clip, thumbnail = nil)
    video = Video.new
    # Attach the video clip and thumbnail
    video.video_clip.attach(clip)
    video.video_thumbnail.attach(thumbnail) if thumbnail&.nonzero?

    # You might not need to manually set video_path here
    video.save!  # Save the video after attaching files
    video
  end

  def create_record(clip, thumbnail = nil)
    video = upload_video(clip, thumbnail)

    # Now that video is saved and attachments are in place, you can set video_path
    video.update!(video_path: Rails.application.routes.url_helpers.rails_blob_path(video.video_clip, only_path: true))
    video
  end

  private_class_method :new
end
