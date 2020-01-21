class Api::V1::ProfilesController < Api::V1::ApiController
	before_action :authorize_request
	before_action :find_job, only: [:show]

	def show
		profile = Profile.where(uuid: params[:id]).first
		if profile
			favorited_freelancers = @current_user.favorites_freelancers.pluck(:id) rescue []
			invite_id = profile.user.invites.where(sender_id: @current_user.id, job_id: @job)
			contract_id = profile.user.received_contracts.where(job_id: @job)
			render json: profile, serializer: ProfileSerializer, favorited_freelancers: favorited_freelancers, invite_id: invite_id, contract_id: contract_id
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
				@current_user.update_attributes(:profile_created => true)
				render :json => {success: true, user: @current_user, message: "Profile created", status: 200}
			else
				render_error(@profile.errors.full_messages, 422)
			end
		else
			render_error("Profile already created", 422)
		end
	end

	def edit
		@profile = Profile.where(uuid: params[:id]).first
	end

	def update
		@profile = Profile.where(uuid: params[:id]).first
		# if params[:profile][:skill]
		# 	@profile.skill = (params[:profile][:skill]).try(:join, (','))
		# 	@profile.save
		# end
		if @profile.update(update_profile_params)
			@current_user.update_attributes(:professional_profile_created => true)
			render json: @profile, serializer: ProfileSerializer, success: true, message: "Profile updated", status: 200
		else
			render_error(@profile.errors.full_messages, 422)
		end
	end

	private

	def profile_params
		params.require(:profile).permit(:profile_type, :profile_picture, :resume, :current_location_country, :current_location_city, :citizenship_country, :citizenship_full_name, :skype_user_name, :english_proficiency, :skill, :category, :linkedin_profile, :development_experience, :current_company_name, :current_job_title, :about_me, :worked_as_freelancer, :start_date,  :working_hours_talfoundry, :search_engine_privacy)
	end

	def update_profile_params
		params.require(:profile).permit(:profile_picture, :current_job_title, :professional_title, :professional_overview, :youtube_video_link, :youtube_video_type, :hourly_rate, :availability, :visibility, :category, :experience_level, :search_engine_privacy,:project_preference, :earnings_privacy, :skill,
			educations_attributes: [:school, :from_date, :to_date, :degree, :area_of_study, :education_description], employments_attributes: [:company_name, :country, :state, :city, :title, :role, :period_month_from, :period_year_from, :period_month_to, :period_year_to, :employment_description], certifications_attributes: [:certification_name, :certification_link])
	end

	def find_job
		@job = Job.find_by_uuid(params[:job_uuid]).try(:id)
	end

end
