class Api::V1::AdminController < Api::V1::ApiController
	
	before_action :authorize_request


	def approve_freelancer
		freelancer_user = User.find(params[:id])
		freelancer_user.account_approved = true
		freelancer_user.save
	end

end
