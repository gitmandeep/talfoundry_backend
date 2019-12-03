class Api::V1::UsersController < Api::V1::ApiController
	before_action :authorize_request, except: [:create, :confirm_email, :user_full_name]

  def index
    @users = User.all.order(created_at: :desc)
    render json: @users, status: :ok
  end

  def user_full_name
    @user = User.find_by_email(params[:email])
    if @user
      render json: @user.display_full_name
    else
      render_error('Invalid email', 401)
    end
  end

  def create
    @user = User.new(user_params)
    if @user.role == "Project Manager"
      @user.skip_confirmation!
      @user.confirmed_at = Time.now
    end  
    if @user.save
      render json: @user, status: :created
    else
      render_error(@user.errors.full_messages, 422)
    end
  end

  def update
    @user = User.where(uuid: params[:id]).or(User.where(id: params[:id])).first
    if @user.update(update_user_params.merge(confirmed_at: Time.now)) 
      render json: @user, serializer: ProjectManagerSerializer, success: true, message: "Details updated", status: 200 
    else
      render_error(@user.errors.full_messages, 422)
    end
  end

  def user_details
    @user = User.where(uuid: params[:id]).or(User.where(id: params[:id])).first
    if @user 
      render json: @user, serializer: ProjectManagerSerializer, success: true, status: 200 
    else
      render_error(@user.errors.full_messages, 401)
    end
  end

  def confirm_email
    @user = User.confirm_by_token(params[:confirmation_token])
    if @user.errors.present?
      render_error(@user.errors.full_messages, 401)
    else
      render json: @user, success: true, message: "Email confirmed", status: 200  
    end
  end

  def interview_call_schedule
    UserMailer.with(user: @current_user, slot: params[:slot]).interview_call_schedule_email.deliver_later
    @current_user.update_attributes(:call_schedule => true )
    render json: @current_user, success: true, message: "Email sent", status: 200
  end

  def favorited_freelancers
    freelancers = @current_user.favorites_freelancers
    render json: freelancers, each_serializer: FreelancerSerializer, favorited_freelancers: freelancers.pluck(:id), status: :ok
  end

  def favorited_jobs
    jobs = @current_user.favorite_jobs
    render json: jobs, each_serializer: JobSerializer, favorited_jobs: jobs.pluck(:id), status: :ok
  end


  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :country, :country_id, :role, :company_name, :phone_number)
  end

  def update_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :country, :country_id, :company_name, :phone_number, :image, company_attributes: [:id, :name, :image, :owner, :phone, :vat_id, :time_zone, :address])
  end
end
