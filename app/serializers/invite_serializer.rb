class InviteSerializer < ActiveModel::Serializer
	attributes :id
	has_one :job, serializer: JobSerializer
end
