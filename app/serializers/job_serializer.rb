class JobSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :created_at, :job_title, :job_category, :job_speciality, :job_description, :job_document, :job_type, :job_api_integration, :job_expertise_required, :job_visibility, :number_of_freelancer_required, :job_pay_type, :job_pay_value, :job_experience_level, :job_duration, :job_time_requirement, :job_additional_expertise_required
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

end
