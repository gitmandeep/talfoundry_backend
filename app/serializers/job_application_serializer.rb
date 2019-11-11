class JobApplicationSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :job_id, :cover_letter, :document, :price
	has_many :job_application_answers, serializer: JobApplicationAnswerSerializer
end
