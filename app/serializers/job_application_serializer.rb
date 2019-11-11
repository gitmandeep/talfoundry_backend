class JobApplicationSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :job_id, :cover_letter, :job_application_document, :price
	has_many :job_application_answers, serializer: JobApplicationAnswerSerializer

	def job_application_document
		object.document.try(:url)
	end
end
