class Api::V1::NotificationsController < Api::V1::ApiController
  before_action :authorize_request

  def index
  	notifications = @current_user.notifications.present? ? @current_user.notifications : []
  	render json: notifications, each_serializer: NotificationSerializer, status: :ok
  end

end
