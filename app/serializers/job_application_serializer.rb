class JobApplicationSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :job_id, :cover_letter, :job_application_document, :price, :job_aplication_answer
	#has_many :job_application_answers, serializer: JobApplicationAnswerSerializer

	def job_application_document
		object.document.try(:url)
	end

	def job_aplication_answer
		object.job_application_answers
	end
end
