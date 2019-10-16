class Api::V1::CertificationsController < Api::V1::ApiController
	before_action :authorize_request
	before_action :set_profile, only: [:index, :create]
	before_action :find_employment, only: [:edit, :update, :destroy]


	def index
		certifications = @profile.certifications
		if certifications
      render json: certifications, each_serializer: CertificationSerializer
    else
    	render_error("No certification for user", 404)
    end
	end

	def create
		certification = @profile.certifications.build(certification_params)
		if certification.save
      render json: certification, serializer: CertificationSerializer, success: true, message: "Created", status: 200 
		else
			render_error(certification.errors.full_messages, 422)		
		end
	end

	def edit
	end

	def update
		if @certification.update(certification_params)	
      render json: @certification, serializer: CertificationSerializer, success: true, message: "Updated", status: 200 
		else
			render_error(@certification.errors.full_messages, 422)
		end
	end

	def destroy
		if @certification.destroy
      render json: {success: true, message: "Deleted", status: 200} 
		end
	end

	private
	
	def set_profile
		@profile = @current_user.profile
		render_error("Not found", 404) unless @profile
	end

	def find_employment
		@certification = Certification.find_by_uuid(params[:id])
		render_error("Not found", 404) unless @certification 
	end

	def certification_params
		params.require(:certification).permit(:certification_name, :certification_link)
	end
end
