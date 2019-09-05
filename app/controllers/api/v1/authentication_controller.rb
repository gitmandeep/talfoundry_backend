class Api::V1::AuthenticationController < Api::V1::ApiController
	before_action :authorize_request, except: :login

  def login
    user = User.find_by_email(params[:email])
    if user && user.confirmed_at != nil
      if user&.valid_password?(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),email: user.email }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    else
      if !user
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      else
        render json: { error: 'please confirm your email' }, status: :unauthorized
      end
    end
  end
end
