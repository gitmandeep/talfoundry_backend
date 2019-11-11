class InviteSerializer < ActiveModel::Serializer
	attributes :id, :message
	has_one :job, serializer: JobSerializer
end
