class Api::V1::EducationsController < Api::V1::ApiController
	before_action :authorize_request
	before_action :set_profile, only: [:index,:create]
	before_action :find_education, only: [:edit,:update,:destroy]

	def index
		educations = @profile.educations
		if educations
      render json: educations, each_serializer: EducationSerializer
    else
    	render_error("No education for user", 404)
    end
	end

	def create
		education = @profile.educations.build(education_params)
		if education.save
      render json: education, serializer: EducationSerializer, success: true, message: "Created", status: 200 
		else
			render_error(education.errors.full_messages, 422)		
		end
	end

	def edit
	end

	def update
		if @education.update(education_params)	
      render json: @education, serializer: EducationSerializer, success: true, message: "Education updated", status: 200 
		else
			render_error(@education.errors.full_messages, 422)
		end
	end

	def destroy
		if @education.destroy
      render json: {success: true, message: "Deleted", status: 200} 
		end
	end

	private

	def set_profile
		@profile = @current_user.profile
		render_error("Not found", 404) unless @profile
	end

	def find_education
		@education = Education.find_by_id(params[:id])
		render_error("Not found", 404) unless @education
	end

	def education_params
		params.require(:education).permit(:school, :from_date, :to_date, :degree, :area_of_study, :education_description)
	end
end
