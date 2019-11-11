class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :recipient_id, :message, :message_type, :read_at
end
