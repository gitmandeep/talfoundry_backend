class Api::V1::FreelancerController < Api::V1::ApiController
	before_action :authorize_request

	def freelancer_details
		freelancer = User.find_by_id(params[:id])
		if freelancer
			render json: freelancer, serializer: FreelancerSerializer, status: :ok
		else
			render_error('Invalid user', 401)
		end
	end
end
