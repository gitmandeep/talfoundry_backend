class ContractSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
	attributes :title
  attributes :contract_uniq_id
	attributes :payment_mode
	attributes :hourly_rate
	attributes :time_period
	attributes :time_period_limit
	attributes :start_date
	attributes :weekly_payment
	attributes :description
	attributes :attachment
	attributes :status
	attributes :fixed_price_mode
	attributes :fixed_price_amount
	attributes :hired_by_id
	attributes :freelancer_id
	attributes :created_at
  attributes :status_updated_at
  attributes :job_uuid
  attributes :job_title
  attributes :job_category
  attributes :job_description
  attributes :freelacer_name
  attributes :freelacer_picture


	has_one :hired_by, serializer: ProjectManagerSerializer
	has_many :milestones, serializer: MilestoneSerializer

	#has_one :job, serializer: JobSerializer

	def attachment
		object.attachment.try(:url)
	end

	def job_uuid
		object.job.try(:uuid)
	end

	def job_title
		object.job.try(:job_title)
	end

	def job_category
		object.job.try(:job_category)
	end

	def job_description
		object.job.try(:job_description)
	end

	def freelacer_name
    object.try(:freelancer).try(:display_full_name)
  end

  def freelacer_picture
    object.try(:freelancer).try(:profile) ? object.freelancer.profile.profile_picture.try(:url) : "" 
  end

end