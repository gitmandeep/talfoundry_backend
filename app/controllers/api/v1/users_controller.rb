class Api::V1::UsersController < Api::V1::ApiController
	before_action :authorize_request, except: [:create, :confirm_email]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def user_full_name
    @user = User.find_by_email(params[:email])
    if @user
      render json: @user.display_full_name
    else
      #render json: { errors: 'Invalid email' }, status: :unauthorized
      render_error('Invalid email', 401)
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      #render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      render_error(@user.errors.full_messages, 422)
    end
  end

  def confirm_email
    @user = User.confirm_by_token(params[:confirmation_token])
    if @user.errors
      render_error(@user.errors.full_messages, 401)
      #redirect_to "http://localhost:3000/login_page/mail"
    else
      render json: { @user, success: true, message: "Email confirmed" }, status: 200
      #confirm_email_error  
    end
  end


  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :country, :role)
  end

  # def confirm_email_error
  #   #render json: { errors: 'Invalid confirmation token' }, status: :unauthorized
  #   render_error('Invalid confirmation token', 401)
  # end
end
