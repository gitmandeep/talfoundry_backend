module Api::V1::Concerns
  module Notify
    extend ActiveSupport::Concern

    def notify_user(sender_id, recipient_id, notifier_uuid=nil, type, message, activity)
      notification = Notification.new
      notification.sender_id = sender_id
      notification.recipient_id = recipient_id
      notification.notifier_uuid = notifier_uuid
      notification.message_type = type
      notification.message = message
      notification.activity = activity
      notification.save!
    end
  end
end
