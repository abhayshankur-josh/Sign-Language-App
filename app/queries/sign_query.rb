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
    @signs.joins(:video).select("signs.id, signs.title, signs.description, signs.status, videos.video_path")
  rescue Exception => e
    Rails.logger.error "LOG WARNING: SQL ERROR - #{e.full_message}"
  end

  def get_sign_details(id)
    resultSet = Sign.joins("INNER JOIN submissions ON signs.id = submissions.sign_id")
                    .joins("INNER JOIN users AS submitters ON submitters.id = submissions.submitted_by_id")
                    .joins("INNER JOIN videos ON signs.video_id = videos.id")
                    .where("signs.id = #{id}")
                    .select("signs.id,
                      signs.title AS sign_title,
                      signs.description AS sign_description,
                      CASE signs.status
                        WHEN 0 THEN 'approved'
                        WHEN 1 THEN 'pending'
                        WHEN 2 THEN 'rejected'
                      END AS sign_status,
                      signs.created_at AS sign_created_on,
                      signs.updated_at AS sign_updated_on,
                      videos.video_path AS sign_video_url,
                      submitters.full_name AS submitter_name")
    resultSet.first
  rescue Exception => e
    Rails.logger.error "LOG WARNING: SQL ERROR - #{e.full_message}"
  end

  def update_status?(id, status)
    sign = Sign.find(id)
    if Sign.statuses.include?(status)
      sign.update!(status: status)
    else
      raise Exception.new("Invalid Status")
    end
  rescue Exception => e
    Rails.logger.error "LOG WARNING: #{e.full_message}"
    false
  end

  private_class_method :new
end
