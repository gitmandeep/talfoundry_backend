class Api::V1::JobApplicationsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_job_application, only: [:show, :view_job_proposal]

	def create
    job_application = @current_user.job_applications.build(job_application_params)   
    if job_application.save
      job_application.reload
      render json: job_application.uuid, success: true, message: "Job application submitted", status: 200
    else
      render_error(job_application.errors.full_messages, 422)
    end
  end

  def show
    job_application = @job_application.present? ? @job_application : []
    render json: job_application, serializer: JobApplicationSerializer, include: 'job.**', status: :ok
  end

  def view_job_proposal
    job_application = @job_application.present? ? @job_application : []
    render json: job_application, serializer: JobProposalSerializer, include: 'user.profile', status: :ok
  end

	private

  def find_job_application
    @job_application = JobApplication.where(uuid: params[:id]).or(JobApplication.where(id: params[:id])).first
  end

  def job_application_params
    params.require(:job_application).permit(:job_id, :cover_letter, :document, :price, job_application_answers_attributes: [:question_id, :answer, :question_label])
  end
end
