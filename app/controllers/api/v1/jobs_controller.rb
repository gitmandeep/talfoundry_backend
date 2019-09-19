class Api::V1::JobsController < Api::V1::ApiController

	
  def index
  end

	def create
    @job = Job.new(job_params)
    @job_screening_questions = @job.job_screening_questions.build(job_screening_question_params)
    @job_qualifications = @job.job_qualifications.build(job_qualification_params)
    if @job.save
      render :json => {success: true, message: "Job created", status: 200, job: @job, job_screening_questions: @job.job_screening_questions, job_qualifications: @job.job_qualifications}
    else
      render_error(@job.errors.full_messages, 422)
    end
  end






	private

  def job_params
    params.permit(:job_title,:job_category,:job_description,:job_document,:job_type,:job_api_integration,:job_expertise_required,:job_visibility,:number_of_freelancer_required,:job_pay_type,:job_experience_level,:job_duration,:job_time_requirement)
  end

  def job_screening_question_params
    params.permit(:job_question_label,:job_question)
  end

   def job_qualification_params
    params.permit(:freelancer_type,:job_success_score,:billed_on_talfoundry,:english_level,:rising_talent,:qualification_group,:location)
  end
end
