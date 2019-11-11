class Api::V1::JobApplicationsController < Api::V1::ApiController
  before_action :authorize_request

	def create
    job_application = @current_user.job_applications.build(job_application_params)   
    if job_application.save
      job_application.reload
      render json: { success: true, message: "Job application submitted", status: 200 }
    else
      render_error(job_application.errors.full_messages, 422)
    end
  end

	private

  def job_application_params
    params.require(:job_application).permit(:job_id, :cover_letter, :document, :price, job_application_answers_attributes: [:question_id, :answer])
  end
end
