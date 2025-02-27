class Api::V1::SubmissionsController < Api::V1::ApplicationController
    before_action :authorize_request
    before_action :action_submission_params, only: :action_submission

    def get_submissions
        submissions = SubmissionQuery.instance.submissions
        render json: submissions, status: :ok
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    def get_submissions_view
        submissions_view = SubmissionQuery.instance.get_submissions_view
        render json: submissions_view, status: :ok
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    def get_submissions_view_for
        submissions_view = SubmissionQuery.instance.get_submissions_view_for(params[:id])
        render json: submissions_view, status: :ok
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    def action_submission
        ActiveRecord::Base.transaction do
            isSignUpdated = SignQuery.instance.update_status?(params[:signId], params[:signStatus])
            isSubmissionUpdated = SubmissionQuery.instance.update_approver?(params[:submissionId], params[:approverId])
            if isSignUpdated && isSubmissionUpdated
                # Mailer Functions
                render json: { message: "Submission Action Successfull." }, status: :ok
            else
                render json: { error: "Failed" }, status: :expectation_failed
            end
        end
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    private

    def action_submission_params
        params.permit(:submissionId, :approverId, :signId, :signStatus)
    rescue Exception => e
        Rails.logger.error "LOG WARNING: Invalid Params - #{e.full_message}"
        nil
    end
end
