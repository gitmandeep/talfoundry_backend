class Api::V1::NotificationsController < Api::V1::ApiController
  before_action :authorize_request

  def index
  	notifications = @current_user.notifications
  	notifications.present? ? (render json: notifications, each_serializer: NotificationSerializer) : (render json: { error: 'No notifications' }, status: 404)
  end

end
