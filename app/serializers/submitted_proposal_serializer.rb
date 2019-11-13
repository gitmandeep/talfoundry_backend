class SubmittedProposalSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :created_at, :job_title, :client_name

  def job_title
  	object.try(:job).try(:job_title)
  end

  def client_name
  	object.try(:job).try(:user).try(:display_full_name)
  end

end
