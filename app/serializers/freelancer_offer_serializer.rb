class FreelancerOfferSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :title, :created_at, :time_period_limit, :status, :status_updated_at, :payment_mode, :hourly_rate, :fixed_price_amount, :contract_uniq_id
  attributes :job_title
  attributes :client_name
  attributes :freelacer_name
  attributes :freelacer_picture
  attributes :freelacer_country
  attributes :job_uuid
  attributes :payment_requested?

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

  def payment_requested?
    object.try(:requested_payments).where(status: "requested")
  end

end
