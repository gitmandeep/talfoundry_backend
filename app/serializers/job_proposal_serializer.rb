class JobProposalSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :job_id, :cover_letter, :job_application_document, :price
	belongs_to :user, serializer: FreelancerSerializer

	def job_application_document
		object.document.try(:url)
	end
end
