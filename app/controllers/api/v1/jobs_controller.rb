class Api::V1::JobsController < Api::V1::ApiController
  include Api::V1::Concerns::Search
  before_action :authorize_request
  before_action :find_job, only: [:edit, :update, :destroy, :show, :job_related_freelancer, :invited_freelancer, :get_job_proposals]

  def index
    if params[:search_by_category] || params[:search_by_recommended]
      search_by = params[:search_by_category].present? ? params[:search_by_category] : @current_user.try(:profile).try(:category)
      jobs = Job.search(search_by, operator: "or", fields: [:job_category])
    else
      jobs = params[:search].present? ? Job.search(params[:search]) : Job.order(created_at: :desc).where(:job_visibility => "Anyone")
    end
    if params[:search]
      if @current_user.search_histories.where("keyword ~* ?", params[:search]).order(created_at: :desc).limit(5).uniq.blank?
        create_search_history(params[:search])
      end
    end
    favorited_jobs = @current_user.favorite_jobs.pluck(:id) rescue []
    jobs.present? ? (render json: jobs, each_serializer: JobSerializer, favorited_jobs: favorited_jobs) : (render json: [], status: 200)
  end

  def show
    job_application = JobApplication.where(job_id: @job.id, user_id: @current_user.id)
    job_application_id = job_application.present? ? job_application.first.uuid : nil
    @job.present? ? (render json: @job, serializer: JobSerializer, job_application_id: job_application_id) : (render json: { error: 'job not found' }, status: 404)
  end

  def jobs_by_user
    jobs = @current_user.jobs.all.order(created_at: :desc)
    if jobs
      render json: jobs, each_serializer: JobSerializer
    else
      render json: { error: 'jobs not found' }, status: 404
    end
  end

	def create
    job = @current_user.jobs.build(job_params)   
    if job.save
      job.reload
      render json: job, each_serializer: JobSerializer, success: true, message: "Job created", status: 200
    else
      render_error(job.errors.full_messages, 422)
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)  
      render json: @job, serializer: JobSerializer, success: true, message: "Updated", status: 200 
    else
      render_error(@job.errors.full_messages, 422)
    end
  end

  def job_related_freelancer
    if params[:search].present?
      freelancer_users = User.search(params[:search])
      freelancer_users = freelancer_users.results.select{|fu| (fu.role == "freelancer" && fu.account_approved == true && !@job.invites.pluck(:recipient_id).include?(fu.id) && !((@job.job_category.split(',')&(fu.profile.category.split(',')))).empty? )}
    else
      freelancer_users = User.search("#{@job.job_category}" "#{@job.job_speciality}", operator: "or", fields: [:user_skill, :user_category])       
      freelancer_users = freelancer_users.results.select{|fu| (fu.role == "freelancer" && fu.account_approved == true && !@job.invites.pluck(:recipient_id).include?(fu.id) )}     
    end
    if freelancer_users.present?
      render json: freelancer_users, each_serializer: FreelancerSerializer, status: :ok
    else
      render_error("Not found", 404)
    end
  end

  def invited_freelancer
    invited_freelancers = User.where(id: @job.invites.pluck(:recipient_id))
    if invited_freelancers.present?
      render json: invited_freelancers, each_serializer: FreelancerSerializer, status: :ok
    else
      render_error("Not found", 404)
    end  
  end

  def get_job_proposals
    job_proposals = @job.job_applications.present? ? @job.job_applications : []
    render json: job_proposals, each_serializer: JobProposalSerializer, include: ['user.profile'], status: :ok
  end

	private

  def find_job
    @job = Job.where(uuid: params[:id]).or(Job.where(id: params[:id])).first
    render_error("Not found", 404) unless @job
  end

  def job_params
    params.require(:job).permit(:job_title, {:job_category => [] } , {:job_speciality => [] }, :job_description,:job_document,:job_type,:job_api_integration, {:job_expertise_required => []}, {:job_additional_expertise_required => []} , :job_visibility,:number_of_freelancer_required,:job_pay_type, :job_pay_value, :job_experience_level,:job_duration,:job_time_requirement,job_screening_questions_attributes: [:job_question_label,:job_question], job_qualifications_attributes:  [:english_level,:location])
  end
end
