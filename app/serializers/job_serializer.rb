class JobSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :created_at
	attributes :job_title
	attributes :job_category
	attributes :job_description
	attributes :job_document
	attributes :job_type
	attributes :job_api_integration
	attributes :job_expertise_required
	attributes :job_visibility
	attributes :number_of_freelancer_required
	attributes :job_pay_type
	attributes :job_experience_level
	attributes :job_duration
	attributes :job_time_requirement
	attributes :job_additional_expertise_required

	has_one :user, serializer: UserSerializer
	has_many :job_screening_questions, serializer: JobScreeningQuestionSerializer
	has_many :job_qualifications, serializer: JobQualificationSerializer



	def job_document
		object.job_document.try(:url)
	end

	def job_category
		object.job_category.try(:split, (','))
	end

	def job_expertise_required
		object.job_expertise_required.try(:split, (','))
	end

	def job_additional_expertise_required
		object.job_additional_expertise_required.try(:split, (','))
	end

end






