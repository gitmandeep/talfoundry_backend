class Api::V1::ProfilesController < Api::V1::ApiController
	before_action :authorize_request

	def show
	end

	def new
		@profile = Profile.new()
	end

	def create
		unless @current_user.profile.present? 
			@profile = @current_user.build_profile(profile_params)
			if @profile.save
				@current_user.update_attributes(:profile_created => true )	
				render :json => {success: true, message: "Profile created", status: 200} 
			else
				render_error(@profile.errors.full_messages, 422)
			end
		else
			render_error("Profile already created", 422)	
		end
	end


	private

	def profile_params
		params.permit(:profile_picture , :resume , :current_location_country , :current_location_city , :citizenship_country , :citizenship_full_name , :skype_user_name , :english_proficiency , :skill , :linkedin_profile , :github_profile , :personal_website , :development_experience , :look_for_in_company , :project_type_to_work , :project_contributed_on , :current_company_name , :current_job_title , :about_me , :worked_as_freelancer , :freelancing_pros_cons , :start_date , :current_working_hours , :working_hours_talfoundry , :engagement_time , :key_success_point , :problem_handling_strategy)
	end
	
end

