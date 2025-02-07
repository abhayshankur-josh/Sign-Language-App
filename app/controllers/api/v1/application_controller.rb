require_relative "../json_web_token"

class Api::V1::ApplicationController < ApplicationController
    protect_from_forgery with: :null_session

    def not_found
        render json: { error: "not_found" }
    end

    def authorize_request
        header = request.headers["Authorization"]
        header = header.split(" ").last if header
        begin
            @decoded = JsonWebToken.decode(header)
            @current_user = User.find_by(id: @decoded[:user_id], jti: @decoded[:jti_id])
            # p "current user: #{@current_user}"
            raise Exception.new("Token has been revoked!") if @current_user.nil?
        rescue ActiveRecord::RecordNotFound => e
            render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        rescue Exception => e
            render json: { errors: e.message }, status: :precondition_failed
        end
    end
end
