class UserMailer < ApplicationMailer

	def interview_call_schedule_email
    @user = params[:user] 
    @slot = params[:slot]
    mail(to: @user.email, subject: 'Interview Call')    
  end

end
