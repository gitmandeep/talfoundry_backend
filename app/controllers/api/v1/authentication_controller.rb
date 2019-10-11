class Api::V1::AuthenticationController < Api::V1::ApiController
	before_action :authorize_request, except: [:login, :admin_login]

  def login
    user = User.find_by_email(params[:email])
    if user.confirmed_at != nil
      if user.valid_password?(params[:password])
        token = JsonWebToken.encode(user_id: user.id, email: user.email, first_name: user.first_name, last_name: user.last_name, role: user.role, profile_created: user.profile_created, profile_picture: (user.profile ? user.profile.profile_picture.try(:url) : ""), profile_id: (user.profile ? user.profile.id : ""), professional_profile_created: user.professional_profile_created )
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),email: user.email, user: user, profile_id: (user.profile ? user.profile.id : ""), profile_picture: (user.profile ? user.profile.profile_picture.try(:url) : ""), professional_profile_created: user.professional_profile_created }, status: :ok
      else
        render_error('Invalid password', 401)
      end
    else
      render_error('Please confirm your email', 401)
    end
  end

  def admin_login
    user = User.find_by_email(params[:email])
    if user.present? && user.role == "admin"
      if user.valid_password?(params[:password])
        token = JsonWebToken.encode(user_id: user.id, email: user.email, first_name: user.first_name, last_name: user.last_name, role: user.role)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),email: user.email, user: user}, status: :ok
      else
        render_error('Invalid password', 401)
      end
    else
      render_error('Invalid Email', 401)
    end
  end

end
