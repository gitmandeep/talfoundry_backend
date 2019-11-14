class Api::V1::NotificationsController < Api::V1::ApiController
  before_action :authorize_request

  def index
  	notifications = @current_user.notifications.present? ? @current_user.notifications.order(created_at: :desc) : []
  	render json: notifications, each_serializer: NotificationSerializer, count: notifications.try(:unread).try(:count), status: :ok
  end

  def update
  	@current_user.notifications.unread.update_all(read_at: Time.now)
  	render json: {succes: true, status: 200}
  end

end
