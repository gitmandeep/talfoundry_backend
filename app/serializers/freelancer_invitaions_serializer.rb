class FreelancerInvitaionsSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :message
  attributes :created_at
  attributes :status_updated_at
  attributes :status
  attributes :job_title
  attributes :client_name


  def job_title
  	object.try(:job).try(:job_title)
  end

  def client_name
  	object.try(:sender).try(:display_full_name)
  end

end
