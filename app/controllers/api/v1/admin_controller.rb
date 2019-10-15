class Api::V1::AdminController < Api::V1::ApiController
	
	before_action :authorize_request

	def approve_freelancer
		freelancer_user = User.find_by_id(params[:id])
		if freelancer_user
			freelancer_user.account_approved = true
			freelancer_user.save
      render json: { success: true, message: "Profile approved", status: 200 }
    else
    	render_error("Not found", 401)
    end
	end

	def block_freelancer
		freelancer_user = User.find_by_id(params[:id])
		if freelancer_user
			freelancer_user.account_active = false
			freelancer_user.save
      render json: { success: true, message: "Profile blocked", status: 200 }
    else
    	render_error("Not found", 401)
    end
	end

end
