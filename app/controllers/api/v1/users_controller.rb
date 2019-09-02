class Api::V1::UsersController < Api::V1::ApiController
	before_action :authorize_request, except: :create


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


  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :country, :role)
    #params.require(:users).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
