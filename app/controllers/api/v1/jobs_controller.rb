class Api::V1::JobsController < Api::V1::ApiController
  before_action :authorize_request
	
  def index
    jobs = Job.all
    if jobs
      render json: jobs, each_serializer: JobSerializer
    else
      render json: { error: 'jobs not found' }, status: 404
    end
  end

  def show
    job = Job.find(params[:id])
    if job
      render json: job, serializer: JobSerializer
    else
      render json: { error: 'job not found' }, status: 404
    end
  end

  def jobs_by_user
    jobs = @current_user.jobs.all
    if jobs
      render json: jobs, each_serializer: JobSerializer
    else
      render json: { error: 'jobs not found' }, status: 404
    end
  end


	def create
    job = @current_user.jobs.build(job_params)
    job.job_category = params[:job_category].join(",")
    job.job_expertise_required = params[:job_expertise_required].join(",")
    job.job_additional_expertise_required = params[:job_additional_expertise_required].join(",")

    job_questions = params[:job_screening_questions]
    job_questions.each do |job_question| 
      job_screening_questions = job.job_screening_questions.build(:job_question => job_question)
    end
    job_qualifications = job.job_qualifications.build(job_qualification_params)
    
    if job.save
      render :json => {success: true, message: "Job created", status: 200, job: job}
    else
      render_error(job.errors.full_messages, 422)
    end 
  end


	private

  def job_params
    params.permit(:job_title, {:job_category => [] } ,:job_description,:job_document,:job_type,:job_api_integration,{:job_expertise_required => []}, {:job_additional_expertise_required => []}, :job_visibility,:number_of_freelancer_required,:job_pay_type,:job_experience_level,:job_duration,:job_time_requirement, {:job_screening_questions_attributes => [:job_question]}, {:job_qualifications_attributes => {}})
  end

  # def job_screening_question_params
  #   params.permit(:job_question_label,:job_question)
  # end

  def job_qualification_params
    params.require(:job_qualifications).permit(:freelancer_type,:job_success_score,:billed_on_talfoundry,:english_level,:rising_talent,:qualification_group,:location)
  end
end
