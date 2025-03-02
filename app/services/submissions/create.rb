class Submissions::Create
    def initialize(attribute)
      @submission = attribute
    end

    def call
        ActiveRecord::Base.transaction do
            videoId = upload_video
            signId = create_sign(videoId)
            publisherId = get_user
            submissionId = create_submission(publisherId, signId)
            if submissionId
                Rails.logger.info "Uploaded Successfully"
                return { success: true, message: "Uploaded Successfully" }
            else
                Rails.logger.info "Upload failed."
                return { success: false, message: "Upload failed." }
            end
        end
    rescue Exception => e
        Rails.logger.error "Exception: #{e.full_message}"
        { success: false, message: "Exception!" }
    end

    private

    def upload_video
        VideoQuery.instance.create_record(@submission[:videoFile], @submission[:thumbnailFile])
    end

    def create_sign(videoId)
        SignQuery.instance.add_sign(@submission[:videoTitle], @submission[:videoDescription], videoId)
    end

    def get_user
        UserQuery.instance.get_user_id(@submission[:publisherEmail])
    end

    def create_submission(publisherId, signId)
        SubmissionQuery.instance.add_submission(publisherId, signId)
    end
end
