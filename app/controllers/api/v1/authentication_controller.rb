class Api::V1::AuthenticationController < Api::V1::ApiController
	before_action :authorize_request, except: :login

  def login
    user = User.find_by_email(params[:email])
    if user.confirmed_at != nil
      if user&.valid_password?(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                       email: user.email }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    else
      render json: { error: 'please confirm your account' }, status: :unauthorized
    end
  end
end
