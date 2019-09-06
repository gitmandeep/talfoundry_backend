class Api::V1::UsersController < Api::V1::ApiController
	before_action :authorize_request, except: [:create, :confirm_email]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def confirm_email
    @user = User.find(params[:id])
    if @user.confirmation_token == params[:confirmation_token]
      @user.update_attributes(confirmed_at: Time.now, updated_at: Time.now)
      flash.now[:notice] = 'Successfully checked in'
      redirect_to "http://localhost:3000/login_page/mail"
    else
      confirm_email_error  
    end
  end


  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :country, :role)
  end

  def confirm_email_error
    render json: { errors: 'Invalid confirmation token' }, status: :unauthorized
  end
end
