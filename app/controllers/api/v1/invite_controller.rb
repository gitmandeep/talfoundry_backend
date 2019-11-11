class Api::V1::InviteController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_invite, only: [:update, :show]

	def create
		@invite = Invite.new(invite_params) # Make a new Invite
		@invite.sender_id = current_user.id # set the sender to the current user
		@invite.status = "Open" # set status of invitaion
		if @invite.save
		  InviteMailer.with(invite: @invite).job_invite.deliver
		  notify_user(@current_user.id, @invite.recipient_id, "Job invitation", "New invitation for a job")
			render json: { success: true, message: "Invitaion sent successfully..!", status: 200 }
		else
			render_error("Not found", 401)
		end
	end

	def update
		if @invite.update(invite_params)
			@invite.status_updated_at = Time.now
			@invite.save!
			notify_user(@invite.recipient_id, @invite.sender_id, "Invitation update", "Your invitation updated by freelancer")
			render json: { success: true, message: "Invite updated successfully...!", status: 200 }
		else
			render_error(@invite.errors.full_messages, 422)
		end
	end

	def show
		@invite.present? ? (render json: @invite, serializer: InviteSerializer, include: 'job.**') : (render json: { error: 'Invite not found' }, status: 404)
	end

	private

  def invite_params
    params.require(:invite).permit(:job_id, :recipient_id, :message, :status)
  end

  def find_invite
  	@invite = Invite.find(params[:id])
  end

  def notify_user(sender_id,recipient_id, type, message)
  	notification = Notification.new
  	notification.sender_id = sender_id
  	notification.recipient_id = recipient_id
  	notification.message = message
  	notification.message_type = type
  	notification.save!
  end

end
