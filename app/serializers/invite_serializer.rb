class InviteSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :message
	has_one :job, serializer: JobSerializer
end
