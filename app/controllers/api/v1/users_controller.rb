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
    render json: @current_user, success: true, message: "Email sent", status: 200
  end


  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :country, :role, :company_name, :phone_number)
  end

end
