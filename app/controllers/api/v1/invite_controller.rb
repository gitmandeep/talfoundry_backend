class Api::V1::InviteController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_invite, only: [:update, :show]

	def create
		@invite = Invite.new(invite_params) # Make a new Invite
		@invite.sender_id = current_user.id # set the sender to the current user
		@invite.status = "Open" # set status of invitaion
		if @invite.save
		  #InviteMailer.job_invite(@invite).deliver
			render json: { success: true, message: "Invitaion was send successfully..!", status: 200 }
		else
			render_error("Not found", 401)
		end
	end

	def update
		if @invitation.update(invite_params)
			@invitation.status_updated_at = Time.now
			@invitation.save!
			render json: { success: true, message: "Invitation updated successfully...!", status: 200 }
		else
			render_error(@invitation.errors.full_messages, 422)
		end
	end

	def show
		@invitation.present? ? (render json: @invitation, serializer: InviteSerializer) : (render json: { error: 'Invite not found' }, status: 404)
	end

	private

  def invite_params
    params.require(:invite).permit(:job_id, :recipient_id, :message, :status)
  end

  def find_invite
  	@invitation = Invite.find(params[:id])
  end

end
