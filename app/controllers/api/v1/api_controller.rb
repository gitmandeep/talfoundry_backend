class Api::V1::ApiController < ApplicationController
	skip_before_action :verify_authenticity_token

  def authorize_request
    header = request.headers['Authorization']
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status:  401
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status:  401
    end
  end

  def render_error(message, status_code = 404)
    render json: { success: false, message: message, status: status_code }
  end

end
