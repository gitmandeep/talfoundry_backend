class Api::V1::ProjectManagersController < Api::V1::ApiController
  before_action :authorize_request

	def index
		@project_managers = User.where(role: "Project Manager")
		render json: @project_managers, each_serializer: ProjectManagerSerializer 
	end

	def show
    @project_manager = User.where(uuid: params[:id]).or(User.where(id: params[:id])).first
    if @project_manager 
      render json: @project_manager, serializer: ProjectManagerSerializer, success: true, status: 200 
    else
      render_error(@project_manager.errors.full_messages, 401)
    end
  end

end
