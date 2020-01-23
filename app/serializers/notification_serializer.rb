class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :sender_id, :recipient_id, :message, :message_type, :read_at, :created_at, :notification_count, :notifier_uuid, :activity

  def notification_count
    @instance_options[:count]
  end
end
