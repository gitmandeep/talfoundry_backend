class ArchivedProposalSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :created_at, :job_title, :client_name, :freelancer_uuid, :job_uuid

  def job_title
  	object.try(:job).try(:job_title)
  end

  def client_name
  	object.try(:job).try(:user).try(:display_full_name)
  end

  def freelancer_uuid
  	object.try(:user).try(:uuid)
  end

  def job_uuid
  	object.try(:job).try(:uuid)
  end

end
