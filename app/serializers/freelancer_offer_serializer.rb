class FreelancerOfferSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :title
  attributes :job_uuid
  attributes :created_at
  attributes :time_period_limit
  attributes :status
  attributes :status_updated_at
  attributes :payment_mode
  attributes :hourly_rate
  attributes :fixed_price_amount
  attributes :contract_uniq_id
  attributes :job_title
  attributes :client_name
  attributes :freelacer_name
  attributes :freelacer_country
  attributes :freelacer_picture

  has_many :milestones, serializer: MilestoneSerializer


  def job_title
  	object.try(:job).try(:job_title)
  end

  def client_name
  	object.try(:hired_by).try(:display_full_name)
  end

  def freelacer_name
    object.try(:freelancer).try(:display_full_name)
  end

  def freelacer_picture
    object.try(:freelancer).try(:profile) ? object.freelancer.profile.profile_picture.try(:url) : "" 
  end

  def freelacer_country
    object.try(:freelancer).try(:profile) ? object.freelancer.profile.current_location_country : "" 
  end


  def job_uuid
    object.job.uuid
  end

end
