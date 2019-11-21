class FreelancerOfferSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :title
  attributes :job_uuid
  attributes :created_at
  attributes :status
  attributes :status_updated_at
  attributes :contract_uniq_id
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
