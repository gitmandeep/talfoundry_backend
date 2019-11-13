class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :recipient_id, :message, :message_type, :read_at, :created_at, :notification_count

  def notification_count
  	@instance_options[:count]
  end
end
