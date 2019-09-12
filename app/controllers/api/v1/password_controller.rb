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


end
