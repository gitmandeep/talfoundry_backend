class Api::V1::FreelancerController < Api::V1::ApiController
	before_action :authorize_request

	def freelancer_index
    freelancer_users = User.where({ role: "freelancer", profile_created: true })
    render json: freelancer_users, each_serializer: FreelancerSerializer, status: :ok
  end

	def freelancer_details
		freelancer = User.find_by_id(params[:id])
		if freelancer
			render json: freelancer, serializer: FreelancerSerializer, status: :ok
		else
			render_error('Invalid user', 401)
		end
	end
	
end
