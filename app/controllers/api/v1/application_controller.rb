require_relative "../json_web_token"

class Api::V1::ApplicationController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :authorize_request, only: :not_found

    def not_found
        render json: { error: "not_found" }
    end

    private

    def authorize_request
        header = request.headers["Authorization"]
        header = header.split(" ").last if header
        begin
            @decoded = JsonWebToken.decode(header)
            if @decoded
                raise Exception.new("Token has expired!") if Time.parse(@decoded[:expiry]) < Time.now
                @current_user = User.find_by(id: @decoded[:user_id], jti: @decoded[:jti_id])
                raise Exception.new("Token has been revoked!") if @current_user.nil?
            else
                raise Exception.new("Provide Authorization value.")
            end
        rescue ActiveRecord::RecordNotFound => e
            render json: { error: e.message }, status: :precondition_failed
        rescue JWT::DecodeError => e
            render json: { error: e.message }, status: :precondition_failed
        rescue Exception => e
            render json: { error: e.message }, status: :unauthorized
        end
    end

    def authorize_request_for_logout
        header = request.headers["Authorization"]
        header = header.split(" ").last if header
        begin
            @decoded = JsonWebToken.decode(header)
            if @decoded
                @current_user = User.find_by(id: @decoded[:user_id], jti: @decoded[:jti_id])
                raise Exception.new("Token has been revoked!") if @current_user.nil?
            else
                raise Exception.new("Provide Authorization value.")
            end
        rescue ActiveRecord::RecordNotFound => e
            render json: { error: e.message }, status: :precondition_failed
        rescue JWT::DecodeError => e
            render json: { error: e.message }, status: :precondition_failed
        rescue Exception => e
            render json: { error: e.message }, status: :unauthorized
        end
    end
end
