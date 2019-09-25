class JobSerializer < ActiveModel::Serializer
  attributes :id
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
end

