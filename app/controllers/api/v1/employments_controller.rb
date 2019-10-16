class Api::V1::EmploymentsController < Api::V1::ApiController
	before_action :authorize_request
	before_action :set_profile, only: [:index, :create]
	before_action :find_employment, only: [:edit, :update, :destroy]


	def index
		employments = @profile.employments
		if employments
      render json: employments, each_serializer: EmploymentSerializer
    else
    	render_error("No employment for user", 404)
    end
	end

	def create
		employment = @profile.employments.build(employment_params)
		if employment.save
      render json: employment, serializer: EmploymentSerializer, success: true, message: "Created", status: 200 
		else
			render_error(employment.errors.full_messages, 422)		
		end
	end

	def edit
	end

	def update
		if @employment.update(employment_params)	
      render json: @employment, serializer: EmploymentSerializer, success: true, message: "Updated", status: 200 
		else
			render_error(@employment.errors.full_messages, 422)
		end
	end

	def destroy
		if @employment.destroy
      render json: {success: true, message: "Deleted", status: 200} 
		end
	end

	private

	def set_profile
		@profile = @current_user.profile
		render_error("Not found", 404) unless @profile
	end

	def find_employment
		@employment = Employment.find_by_uuid(params[:id])
		render_error("Not found", 404) unless @employment 
	end

	def employment_params
		params.require(:employment).permit(:company_name, :country, :state, :city, :title, :role, :period_month_from, :period_year_from, :period_month_to, :period_year_to, :employment_description)
	end
end
