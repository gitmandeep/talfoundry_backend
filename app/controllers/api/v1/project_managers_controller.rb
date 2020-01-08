class Api::V1::ProjectManagersController < Api::V1::ApiController
  before_action :authorize_request

	def index
		@project_managers = User.where(role: "Project Manager")
		render json: @project_managers, each_serializer: ProjectManagerSerializer 
	end

end
