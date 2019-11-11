class InviteMailer < ApplicationMailer

  def job_invite
  	@invite = params[:invite] 
  	mail(to: @invite.recipient.email, subject: 'Job Invitation')
  end

  # def invite_update
  # 	@invite = params[:invite] 
  # 	mail(to: @invite.sender.email, subject: 'Job Invitation Status')
  # end


end
