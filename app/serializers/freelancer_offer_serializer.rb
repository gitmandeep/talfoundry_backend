class FreelancerOfferSerializer < ActiveModel::Serializer
  attributes :id
  attributes :job_uuid
  attributes :created_at
  attributes :status
  attributes :job_title
  attributes :client_name

  def job_title
  	object.try(:job).try(:job_title)
  end

  def client_name
  	object.try(:hired_by).try(:display_full_name)
  end

  def job_uuid
    object.job.uuid
  end

end
