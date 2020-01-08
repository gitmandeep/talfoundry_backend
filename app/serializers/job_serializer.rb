class JobSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :created_at, :job_title, :job_category, :job_speciality, :job_description, :job_document, :job_type, :job_api_integration, :job_expertise_required, :job_visibility, :number_of_freelancer_required, :job_pay_type, :job_pay_value, :job_experience_level, :job_duration, :job_time_requirement, :job_additional_expertise_required, :proposal_count, :favorited_job, :active_contract_count, :is_public, :job_status, :hired_freelancers
  attributes :job_application_id
  #has_one :user, serializer: UserSerializer
  has_one :user, serializer: ProjectManagerSerializer
  has_many :job_screening_questions, serializer: JobScreeningQuestionSerializer
  has_many :job_qualifications, serializer: JobQualificationSerializer

  def job_document
    object.job_document.try(:url)
  end

  def job_category
    object.job_category.try(:split, (','))
  end

  def job_speciality
    object.job_speciality.try(:split, (','))
  end

  def job_expertise_required
    object.job_expertise_required.try(:split, (','))
  end

  def job_additional_expertise_required
    object.job_additional_expertise_required.try(:split, (','))
  end

  def job_application_id
    @instance_options[:job_application_id].present? ? (return @instance_options[:job_application_id]) : (return nil)
  end

  def proposal_count
    object.job_applications.try(:count)
  end

  def active_contract_count
    object.contracts.present? ? object.contracts.active_contract.try(:count) : 0
  end

  def hired_freelancers
    if current_user.is_admin? && object.contracts.try(:active_contract).present?
      object.contracts.active_contract.map{|c| c.freelancer.slice(:first_name, :last_name).merge( c.freelancer.profile.slice(:id, :uuid, :current_job_title, :hourly_rate, :current_location_country, :about_me, :profile_picture) ) }
    end
  end

  def favorited_job
    if @instance_options[:favorited_jobs].present?
      return @instance_options[:favorited_jobs].include? object.id
    else
      return false
    end
  end

  def is_public
    @current_user.present? ? false : true
  end

end
