class JobProposalSerializer < ActiveModel::Serializer
	attributes :id, :uuid
	belongs_to :user, serializer: FreelancerSerializer
end
