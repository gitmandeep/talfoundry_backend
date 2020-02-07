class Api::V1::JobApplicationsController < Api::V1::ApiController
  include Api::V1::Concerns::Notify
  before_action :authorize_request
  before_action :find_job_application, only: [:show, :view_job_proposal, :destroy, :update]

	def create
    job_application = @current_user.job_applications.build(job_application_params)   
    if job_application.save
      job_application.reload
      notify_user(@current_user.id, job_application.job.user_id, job_application.uuid, "New job application", "\"#{job_application.user.display_full_name}\" has applied on the job \"#{job_application.job.try(:job_title)}\" ", "freelancer-proposal")
      render json: job_application.uuid, success: true, message: "Job application submitted", status: 200
    else
      render_error(job_application.errors.full_messages, 422)
    end
  end

  def update
    if @job_application.update(job_application_params)
      if job_application_params[:status] == "archived"
        @job_application.archived_by = @current_user.id
        @job_application.save!
        notify_user(@current_user.id, @job_application.user_id, @job_application.uuid, "Archive job proposal", "\"#{@job_application.job.user.display_full_name}\" has archived your job proposal", "proposal-details")
      elsif job_application_params[:status] == "withdrawal"
        notify_user(@current_user.id, @job_application.job.user_id, @job_application.uuid, "Withdrawa job proposal", "\"#{@job_application.user.display_full_name}\" has withdrawal the job proposal", "proposal-details")
      elsif job_application_params[:status] == "terms changed"        
        notify_user(@current_user.id, @job_application.job.user_id, @job_application.uuid, "Edit job proposal", "\"#{@job_application.user.display_full_name}\" has changed the job proposal", "proposal-details")
      end
      render json: {success: true, status: :ok}
    end
  end

  def get_archived_proposals
    if @current_user.is_hiring_manager?
      @archived_proposals = JobApplication.where(archived_by: @current_user.id)
    else
      @archived_proposals = @current_user.job_applications.where("archived_at is not null")
    end
    render json: @archived_proposals, each_serializer: ArchivedProposalSerializer, message: "Job Proposal archived successfully", status: :ok
  end

  def show
    job_application = @job_application.present? ? @job_application : []
    render json: job_application, serializer: JobApplicationSerializer, include: 'job.**', status: :ok
  end

  def view_job_proposal
    job_application = @job_application.present? ? @job_application : []
    render json: job_application, serializer: JobApplicationSerializer, include: 'user.profile', status: :ok
  end

  def destroy
    if @job_application.destroy
      render json: {success: true, message: "Job application deleted", status: 200} 
    end 
  end

	private

  def find_job_application
    @job_application = JobApplication.where(uuid: params[:id]).first
    @job_application = JobApplication.where(id: params[:id]).first if @job_application.blank?
    render_error("Not found", 404) unless @job_application
  end

  def job_application_params
    params.require(:job_application).permit(:job_id, :cover_letter, :document, :price, :status, :archived_at, job_application_answers_attributes: [:question_id, :answer, :question_label])
  end
end
