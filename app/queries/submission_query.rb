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
    # newSubmission.approved_by = nil
    newSubmission.sign_id = signId
    newSubmission.save!
    newSubmission.id
  rescue Exception => e
    Rails.logger.error "LOG WARNING: #{e.full_message}"
  end
end
