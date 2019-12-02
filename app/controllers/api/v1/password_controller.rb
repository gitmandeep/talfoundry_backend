class Api::V1::PasswordController < Api::V1::ApiController
	before_action :authorize_request, except: [:forgot_password, :reset_password]


	def forgot_password
		@user = User.find_by_email(params[:email])
		if @user 
			@user.send_reset_password_instructions
			render :json => {success: true, message: "Reset password instructions successfully sent to your registered email", status: 200} 
		else
      render_error("Invalid email", 401)
    end
	end

	def reset_password
		@user = User.reset_password_by_token(attributes={:reset_password_token => params[:reset_password_token], :password => params[:password], :password_confirmation => params[:password_confirmation]})	
		unless @user.errors.present?
			render :json => {success: true, message: "Password reset successfully", status: 200}
		else
      render_error(@user.errors.full_messages, 401)
		end 
	end

	def update_password
    @user = User.where(uuid: params[:id]).or(User.where(id: params[:id])).first
    if @user.update_with_password(password_params)
      render json: @user, serializer: ProjectManagerSerializer, success: true, message: "Details updated", status: 200 
    else
      render_error(@user.errors.full_messages, 401)
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
