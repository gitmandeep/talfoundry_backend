class JobProposalSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :job_id, :cover_letter, :job_application_document, :price, :job_aplication_answer, :job_proposal_count
	belongs_to :user, serializer: FreelancerSerializer

	def job_application_document
		object.document.try(:url)
	end

	def job_aplication_answer
		object.job_application_answers
	end

	def job_proposal_count
		@instance_options[:job_proposal_count]
	end
end
