class Api::V1::SubmissionsController < Api::V1::ApplicationController
    before_action :authorize_request

    # GET    /api/v1/submissions
    def get_submissions
        submissions = SubmissionQuery.instance.submissions
        render json: submissions, status: :ok
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    # POST   /api/v1/submissions
    def create_submission
        submission = Submissions::Create.new(create_submission_params)
        result = submission.call
        render json: result[:success] ? { message: result[:message] } : { error: result[:message] }, status: :ok
    end

    # GET    /api/v1/submissions/view
    def get_submissions_view
        submissions_view = SubmissionQuery.instance.get_submissions_view
        render json: submissions_view, status: :ok
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    # GET    /api/v1/submissions/view/:id
    def get_submissions_view_for
        submissions_view = SubmissionQuery.instance.get_submissions_view_for(params[:id])
        render json: submissions_view, status: :ok
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    # POST   /api/v1/submissions/status
    def action_submission
        action = Submissions::Action.new(action_submission_params)
        result = action.call
        render json: result[:success] ? { message: result[:message] } : { error: result[:message] }, status: :ok
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    private

    def action_submission_params
        params.permit(:submissionId, :approverId, :signId, :signStatus, :rejectionReason)
    end

    def create_submission_params
        params.permit(:publisherEmail, :videoTitle, :videoDescription, :thumbnailFile, :videoFile)
    end
end
