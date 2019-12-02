class Api::V1::ProfilesController < Api::V1::ApiController
	before_action :authorize_request

	def show
		profile = Profile.where(uuid: params[:id]).or(Profile.where(id: params[:id])).first  #@current_user.profile Profile.find(params[:id])
    if profile
    	favorited_freelancers = @current_user.favorites_freelancers.pluck(:id) rescue []
    	render json: profile, serializer: ProfileSerializer, favorited_freelancers: favorited_freelancers
    else
			render_error("Profile Not found..!", 422)	
		end
	end

	def new
		@profile = Profile.new()
	end

	def create
		unless @current_user.profile.present? 
			@profile = @current_user.build_profile(profile_params)
			if @profile.save
				@current_user.update_attributes(:profile_created => true )	
				render :json => {success: true, user: @current_user, message: "Profile created", status: 200} 
			else
				render_error(@profile.errors.full_messages, 422)
			end
		else
			render_error("Profile already created", 422)	
		end
	end

	def edit
		@profile = Profile.where(uuid: params[:id]).or(Profile.where(id: params[:id])).first
	end


	def update
		@profile = Profile.where(uuid: params[:id]).or(Profile.where(id: params[:id])).first
		if params[:profile][:skill]
			@profile.skill = (params[:profile][:skill]).try(:join, (','))
			@profile.save
		end
		if @profile.update(update_profile_params)
			@current_user.update_attributes(:professional_profile_created => true )	
      render json: @profile, serializer: ProfileSerializer, success: true, message: "Profile updated", status: 200 
		else
			render_error(@profile.errors.full_messages, 422)
		end
	end



	private

	def profile_params
		params.require(:profile).permit(:profile_type, :profile_picture , :resume , :current_location_country , :current_location_city , :citizenship_country , :citizenship_full_name , :skype_user_name , :english_proficiency , {:skill => []} , {:category => []}, {:certification => []}, :linkedin_profile , :development_experience , :current_company_name , :current_job_title , :about_me , :worked_as_freelancer , :start_date ,  :working_hours_talfoundry)
	end
	
	def update_profile_params
		params.require(:profile).permit(:profile_picture, :current_job_title, :professional_title, :professional_overview, :youtube_video_link, :youtube_video_type, :hourly_rate, :availability, :visibility, :category,
			educations_attributes: [:school, :from_date, :to_date, :degree, :area_of_study, :education_description], employments_attributes: [:company_name, :country, :state, :city, :title, :role, :period_month_from, :period_year_from, :period_month_to, :period_year_to, :employment_description], certifications_attributes: [:certification_name, :certification_link])
	end

end

