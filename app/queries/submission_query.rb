class SubmissionQuery
  attr_reader :submissions

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @submissions = Submission.all
  end

  def add_submission(publisherId, signId)
    newSubmission = Submission.new
    newSubmission.submitted_by_id = publisherId
    newSubmission.sign_id = signId
    newSubmission.save!
    newSubmission.id
  rescue Exception => e
    Rails.logger.error "LOG WARNING: #{e.full_message}"
  end

  def get_submissions_view
    Submission.joins("LEFT JOIN users AS approvers ON approvers.id = submissions.approved_by_id")
                .joins("INNER JOIN signs ON signs.id = submissions.sign_id")
                .joins("INNER JOIN users AS submitters ON submitters.id = submissions.submitted_by_id")
                .joins("INNER JOIN videos ON videos.id = signs.video_id")
                .select("submissions.id, submissions.created_at, submissions.updated_at,
                          submissions.approved_by_id AS approver_id,
                          approvers.full_name AS approver_name,
                          submissions.submitted_by_id AS publisher_id,
                          submitters.full_name AS publisher_name,
                          signs.id AS sign_id,
                          signs.title AS sign_title,
                          signs.description AS sign_description,
                          CASE signs.status
                            WHEN 0 THEN 'approved'
                            WHEN 1 THEN 'pending'
                            WHEN 2 THEN 'rejected'
                          END AS sign_status,
                          signs.video_id AS video_id,
                          videos.video_path AS video_path")
  rescue Exception => e
    Rails.logger.error "LOG WARNING: #{e.full_message}"
  end

  def get_submissions_view_for(id)
    submissions = get_submissions_view
    submissions.find_by(id: id)
  end

  def update_approver?(id, approver_id)
    submission = Submission.find(id)
    if User.exists?(approver_id)
      submission.update!(approved_by_id: approver_id)
      true
    else
      Rails.logger.error "LOG WARNING: Invalid approver ID: #{approver_id}"
      false
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "LOG WARNING: Submission not found: #{e.full_message}"
    false
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "LOG WARNING: Update failed: #{e.full_message}"
    false
  end

  def get_recent_submission_view_for(id)
    submissions = get_submissions_view
    submissions.order(:updated_at).where("approver_id = :id OR publisher_id = :id", id: id).to_a
  end
end
