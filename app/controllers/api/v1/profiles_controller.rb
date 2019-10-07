class Api::V1::ProfilesController < Api::V1::ApiController
	before_action :authorize_request

	def show
		profile = @current_user.profile   #Profile.find(params[:id])
    if profile
    	render json: profile, serializer: ProfileSerializer
    else
			render_error(profile.errors.full_messages, 422)	
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
		profile = Profile.find(params[:id])
	end


	def update
		profile = Profile.find(params[:id])
		if profile.update(update_profile_params)
			@current_user.update_attributes(:professional_profile_created => true )	
      render json: profile, serializer: ProfileSerializer, success: true, message: "Profile updated", status: 200 
		else
			render_error(@profile.errors.full_messages, 422)
		end
	end



	private

	def profile_params
		params.require(:profile).permit(:profile_picture , :resume , :current_location_country , :current_location_city , :citizenship_country , :citizenship_full_name , :skype_user_name , :english_proficiency , {:skill => []} , :linkedin_profile , :github_profile , :personal_website , :development_experience , :look_for_in_company , :project_type_to_work , :project_contributed_on , :current_company_name , :current_job_title , :about_me , :worked_as_freelancer , :freelancing_pros_cons , :start_date , :current_working_hours , :working_hours_talfoundry , :engagement_time , :key_success_point , :problem_handling_strategy)
	end
	
	def update_profile_params
		params.require(:profile).permit({:skill => []}, :current_job_title, :professional_title, :professional_overview, :youtube_video_link, :youtube_video_type, :hourly_rate, :availability,
			educations_attributes: [:school, :from_date, :to_date, :degree, :area_of_study, :education_description], employments_attributes: [:company_name, :country, :state, :city, :title, :role, :period_month_from, :period_year_from, :period_month_to, :period_year_to, :employment_description], certifications_attributes: [:certification_name, :certification_link])
	end

end

