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
              # else
              #     Rails.logger.info "Upload failed."
              #     return { success: false, message: "Upload failed." }
            end
        end
    rescue Exception => e
        Rails.logger.error "Exception: #{e.full_message}"
        { success: false, message: e.message }
    end

    private

    def upload_video
        videoId = VideoQuery.instance.create_record(@submission[:videoFile], @submission[:thumbnailFile])
        unless videoId.is_a? Numeric
            raise Exception.new("Failed to upload Video!")
        end
        videoId
    end

    def create_sign(videoId)
        signId = SignQuery.instance.add_sign(@submission[:videoTitle], @submission[:videoDescription], videoId)
        unless signId.is_a? Numeric
            raise Exception.new("Failed to Create Sign!")
        end
        signId
    end

    def get_user
        userId = UserQuery.instance.get_user_id(@submission[:publisherEmail])
        unless userId.is_a? Numeric
            raise Exception.new("User not found!")
        end
        userId
    end

    def create_submission(publisherId, signId)
        submissionId = SubmissionQuery.instance.add_submission(publisherId, signId)
        unless submissionId.is_a? Numeric
            raise Exception.new("Failed to Create Submission!")
        end
        submissionId
    end
end
