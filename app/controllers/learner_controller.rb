class LearnerController < ApplicationController
    def index
        @current_email = current_user.email
    end

    def create_submission
        result = Submissions::Create.new(upload_params).call
        if result[:success]
            flash[:success] = result[:message]
        else
            flash[:warning] = "Upload failed."
            Rails.logger.error result[:message]
        end
        redirect_to learner_index_path
    end

    private

    def upload_params
        params.permit(:videoFile, :thumbnailFile, :videoTitle, :videoDescription, :publisherEmail)
    end
end
