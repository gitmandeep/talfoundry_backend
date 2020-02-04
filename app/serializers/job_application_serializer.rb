class JobApplicationSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :job_id, :cover_letter, :price, :archived_at, :job_application_document, :job_aplication_answer
  has_one :job, serializer: JobSerializer
  belongs_to :user, serializer: FreelancerSerializer

  def job_application_document
    object.document.try(:url)
  end

  def job_aplication_answer
    object.job_application_answers
  end
end
