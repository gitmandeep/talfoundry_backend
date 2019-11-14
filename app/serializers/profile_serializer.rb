class ProfileSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :user_id
  attributes :profile_type
	attributes :profile_picture
	#attributes :profile_picture_base64
	attributes :current_job_title
	attributes :current_location_country
	attributes :current_location_city
	attributes :professional_title
	attributes :professional_overview
	attributes :category
	attributes :skill
	attributes :user_certification	
	attributes :youtube_video_link
	attributes :hourly_rate
	attributes :availability
	attributes :visibility
	attributes :english_proficiency
	attributes :about_me
	attributes :development_experience
  attributes :name
  attributes :available_jobs
  attributes :search_keywords

  has_many :educations, serializer: EducationSerializer
	has_many :employments, serializer: EmploymentSerializer
	has_many :certifications, serializer: CertificationSerializer


	def user_id
		object.user.id
	end

	def search_keywords
		if object.user.search_histories
			object.user.search_histories.order(created_at: :desc).limit(5).map(&:keyword).uniq
		end
	end
	
	def name
		object.user.try(:first_name) + ' ' + object.user.try(:last_name)
	end

	def profile_picture
		object.profile_picture.try(:url)
	end

	def profile_picture_base64
		if current_user.role != "admin"
			img = open(object.profile_picture.try(:url)) rescue ''
			img_base64 = Base64.encode64(img.read) rescue ''
		else
			''
		end
	end

	def skill
		object.skill.try(:split, (','))
	end

	def category
		object.category.try(:split, (','))
	end

	def user_certification
		object.certification.try(:split, (','))
	end

	def available_jobs
		if current_user.role == "Project Manager"
			jobs_array = []
			jobs = current_user.jobs.select{ |job| job.invites.present? ? job.invites.all.map(&:recipient_id).exclude?(object.user.id) : job }.pluck(:id, :job_title)      
			jobs.each {|a| jobs_array.push({id: a[0], title: a[1]})}
      users_jobs = jobs_array.flatten
		end
		return users_jobs || [] 
	end

end
