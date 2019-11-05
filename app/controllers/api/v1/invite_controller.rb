class Api::V1::InviteController < Api::V1::ApiController
  before_action :authorize_request

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

	private

  def invite_params
    params.require(:invite).permit(:job_id, :recipient_id, :message) 
  end
end