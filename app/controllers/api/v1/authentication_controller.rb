class Api::V1::AuthenticationController < Api::V1::ApiController
	before_action :authorize_request, except: [:login, :admin_login]

  def login
    user = User.find_by_email(params[:email])
    if user.confirmed_at != nil && user.account_active
      if user.valid_password?(params[:password])
        token = JsonWebToken.encode(user_id: user.id, email: user.email, first_name: user.first_name, last_name: user.last_name, role: user.role, profile_created: user.profile_created, call_schedule: user.call_schedule, account_approved: user.account_approved, profile_picture: (user.profile ? user.profile.profile_picture.try(:url) : ""), profile_uuid: (user.profile ? user.profile.uuid : ""), professional_profile_created: user.professional_profile_created )
        time = Time.now + 24.hours.to_i
        # if user.role == "freelancer"
        #   unless user.profile_created
        #     users = User.where(profile_created: true).limit(5)          
        #   end
        # end
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),email: user.email, user: user, profile_uuid: (user.profile ? user.profile.uuid : ""), profile_picture: (user.profile ? user.profile.profile_picture.try(:url) : ""), call_schedule: user.call_schedule, account_approved: user.account_approved, professional_profile_created: user.professional_profile_created, user_job: user.jobs.present? }, status: :ok
      else
        render_error('Invalid password', 401)
      end
    else
      render_error( user.account_active ? 'Please confirm your email' : 'Your account temporarily blocked', 401)
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

#user_list: ( users ? ActiveModel::Serializer::CollectionSerializer.new(users, each_serializer: UserSerializer) : '')

 