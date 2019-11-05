class Api::V1::JobsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_job, only: [:edit, :update, :destroy, :show, :job_related_freelancer, :invited_freelancer]

	
  def index
    if params[:search].present?
      jobs = Job.search(params[:search])
    else
      jobs = Job.order(created_at: :desc).where(:job_visibility => "Anyone")
    end
    if jobs
      render json: jobs, each_serializer: JobSerializer
    else
      render json: { error: 'jobs not found' }, status: 404
    end
  end

  def show
    if @job.present?
      render json: @job, serializer: JobSerializer
    else
      render json: { error: 'job not found' }, status: 404
    end
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
      freelancer_users = freelancer_users.results.select{|fu| (fu.role == "freelancer" && fu.account_approved == true)}
    else
      freelancer_users = User.search("%#{@job.job_category}%" "%#{@job.job_speciality}%", fields: [:user_skill, :user_category])       
        # freelancer_users = User.manager_freelancer_index.includes(:profile).where("category ILIKE ? or skill ILIKE ?","%#{@job.job_category}%", "%#{@job.job_speciality}%").limit(10)
    end
    render json: freelancer_users, each_serializer: FreelancerSerializer, status: :ok
  end

  def invited_freelancer
    invited_freelancers = User.where(id: @job.invites.pluck(:recipient_id))
    if invited_freelancers.present?
      render json: invited_freelancers, each_serializer: FreelancerSerializer, status: :ok
    else
      render_error("Not found", 404)
    end  
  end

	private

  def find_job
    @job = Job.where(uuid: params[:id]).or(Job.where(id: params[:id])).first
    render_error("Not found", 404) unless @job 
  end

  def job_params
    params.require(:job).permit(:job_title, {:job_category => [] } , {:job_speciality => [] }, :job_description,:job_document,:job_type,:job_api_integration, {:job_additional_expertise_required => []}, :job_visibility,:number_of_freelancer_required,:job_pay_type,:job_experience_level,:job_duration,:job_time_requirement,job_screening_questions_attributes: [:job_question_label,:job_question], job_qualifications_attributes:  [:english_level,:location])
  end


end
