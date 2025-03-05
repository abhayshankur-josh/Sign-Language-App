class Submissions::Action
    def initialize(attribute)
      @attribute = attribute
    end

    def call
        ActiveRecord::Base.transaction do
            update_status?
            update_approver?
            send_mail?
            return { success: true, message: "Submission Action Successfull." }
        end
    rescue Exception => e
        Rails.logger.error "Exception: #{e.full_message}"
        { success: false, message: e.message }
    end

    private

    def update_status?
        unless SignQuery.instance.update_status?(@attribute[:signId], @attribute[:signStatus])
            raise Exception.new("Failed to Update Status!")
        end
    end

    def update_approver?
        unless SubmissionQuery.instance.update_approver?(@attribute[:submissionId], @attribute[:approverId])
            raise Exception.new("Failed to Update Approver!")
        end
    end

    def send_mail?
        unless UserMailer.mail_to_publisher_on_submission_action(@attribute[:submissionId], @attribute[:rejectionReason]).deliver_now
            raise Exception.new("Failed to send Mail!")
        end
    end
end
