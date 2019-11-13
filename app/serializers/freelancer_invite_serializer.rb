class FreelancerInviteSerializer < ActiveModel::Serializer
  attributes :id, :job_uuid, :message, :created_at, :status_updated_at, :status, :job_title, :client_name

  def job_title
  	object.try(:job).try(:job_title)
  end

  def client_name
  	object.try(:sender).try(:display_full_name)
  end

  def job_uuid
    object.job.uuid
  end

end
