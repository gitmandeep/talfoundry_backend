class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :user_id, :user_uuid, :profile_type, :profile_picture, :current_job_title, :current_location_country, :current_location_city, :professional_title, :professional_overview, :category, :skill, :user_certification, :youtube_video_link, :hourly_rate, :availability, :visibility, :english_proficiency, :about_me, :development_experience, :experience_level, :search_engine_privacy, :project_preference, :earnings_privacy, :name, :available_jobs, :available_jobs_for_contract, :search_keywords, :favorited_freelancer, :invites_count, :contracts_count, :invite_id, :contract_id, :profile_strength
  #attributes :profile_picture_base64

  has_many :educations, serializer: EducationSerializer
  has_many :employments, serializer: EmploymentSerializer
  has_many :certifications, serializer: CertificationSerializer

  def user_id
  	object.user.id
  end

  def user_uuid
  	object.user.uuid
  end

  def profile_picture
  	object.profile_picture.try(:url)
  end

  def category
  	object.category.try(:split, (','))
  end

  def skill
  	object.skill.try(:split, (','))
  end

  def user_certification
  	object.certification.try(:split, (','))
  end

  def name
  	full_name = object.user.try(:first_name) + ' ' + object.user.try(:last_name)
    if object.try(:search_engine_privacy).present?
      display_name = object.try(:search_engine_privacy) == "Show my full name" ? full_name : object.user.try(:first_name) + ' ' + object.user.try(:last_name).chr
    else
      display_name = full_name
    end
    return display_name
  end

  def available_jobs
  	if current_user && current_user.is_hiring_manager?
  		jobs_array = []
  		jobs = current_user.jobs.select{ |job| job.invites.present? ? job.invites.all.map(&:recipient_id).exclude?(object.user.id) : job }.pluck(:id, :job_title, :uuid)
  		jobs.each {|a| jobs_array.push({id: a[0], title: a[1], uuid: a[2]})}
  		users_jobs = jobs_array.flatten
  	end
  	return users_jobs || []
  end

  def available_jobs_for_contract
  	if current_user && current_user.is_hiring_manager?
  		jobs_array = []
  		jobs = current_user.jobs.select{ |job| job.contracts.present? ? job.contracts.all.map(&:freelancer_id).exclude?(object.user.id) : job }.pluck(:id, :job_title, :uuid)
  		jobs.each {|a| jobs_array.push({id: a[0], title: a[1], uuid: a[2]})}
  		available_jobs_for_contract = jobs_array.flatten
  	end
  	return available_jobs_for_contract || []
  end

  def search_keywords
  	if object.user.search_histories
  		object.user.search_histories.order(created_at: :desc).limit(5).map(&:keyword).uniq
  	end
  end

  def favorited_freelancer
  	if @instance_options[:favorited_freelancers].present?
  		return @instance_options[:favorited_freelancers].include? object.user.id
  	else
  		return false
  	end
  end

  def invites_count
  	invites = object.user.invites
  	invites_count = invites.present? ? invites.open_invites.try(:count) : ''
  	return invites_count
  end

  def contracts_count
  	received_contracts = object.user.received_contracts
  	contracts_count = received_contracts.present? ? received_contracts.pending_offer.try(:count) : ''
  	return contracts_count
  end

  def invite_id
  	@instance_options[:invite_id].present? ? (return @instance_options[:invite_id].first.id) : (return nil)
  end

  def contract_id
  	@instance_options[:contract_id].present? ? (return @instance_options[:contract_id].first.id) : (return nil)
  end

  # def profile_picture_base64
	# 	if current_user.role != "admin"
	# 		img = open(object.profile_picture.try(:url)) rescue ''
	# 		img_base64 = Base64.encode64(img.read) rescue ''
	# 	else
	# 		''
	# 	end
	# end


  def profile_strength
    profile_picture_score =  object.profile_picture.present? ? 20 : 0
    education_score =  object.educations.present? ? 20 : 0
    employment_score =  object.employments.present? ? 20 : 0
    certification_score =  object.certifications.present? ? 40 : 0  
    total_score =  profile_picture_score + education_score + employment_score + certification_score
    return total_score
  end

end
