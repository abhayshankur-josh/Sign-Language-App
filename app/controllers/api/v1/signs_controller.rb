class Api::V1::SignsController < Api::V1::ApplicationController
    before_action :authorize_request
    before_action :update_status_params, only: :update_status

    def get_all
        signs = SignQuery.instance.signs
        render json: signs, status: :ok
    rescue Exception => e
        render json: { error: "Exception: #{e.full_message}" }, status: :expectation_failed
    end

    private

    def update_status_params
        params.permit(:id, :status)
    rescue Exception => e
        Rails.logger.error "LOG WARNING: Invalid Params - #{e.full_message}"
        nil
    end
end
