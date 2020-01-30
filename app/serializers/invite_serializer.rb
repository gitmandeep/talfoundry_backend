class InviteSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :message, :status
  has_one :job, serializer: JobSerializer
end
