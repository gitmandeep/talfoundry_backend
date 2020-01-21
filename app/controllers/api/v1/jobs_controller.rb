class Api::V1::JobsController < Api::V1::ApiController
  include Api::V1::Concerns::Search
  before_action :authorize_request
  before_action :find_job, only: [:edit, :update, :destroy, :show, :job_related_freelancer, :invited_freelancer, :get_job_proposals, :hired_freelancer, :get_job_active_contract]

  def index
    if params[:search_by_category] || params[:search_by_recommended]
      search_by = params[:search_by_category].present? ? params[:search_by_category] : @current_user.try(:profile).try(:category)
      jobs = Job.search(search_by, operator: "or", fields: [:job_category]).results
    else
      jobs = params[:search].present? ? Job.search(params[:search]).results : Job.recent
    end
    if @current_user.is_freelancer? && params[:search].present?
      if @current_user.search_histories.where("keyword ~* ?", params[:search]).order(created_at: :desc).limit(5).uniq.blank?
        create_search_history(params[:search])
      end
    end
    
    favorited_jobs = @current_user.favorite_jobs.pluck(:id) rescue []
    jobs.present? ? (paginate  json: jobs, each_serializer: JobSerializer, favorited_jobs: favorited_jobs, per_page: 10) : (render json: [], status: 200)
  end

  def show
    favorited_jobs = @current_user.favorite_jobs.pluck(:id) rescue []
    job_application = JobApplication.where(job_id: @job.id, user_id: @current_user.id)
    job_application_id = job_application.present? ? job_application.first.uuid : nil
    @job.present? ? (render json: @job, serializer: JobSerializer, favorited_jobs: favorited_jobs, job_application_id: job_application_id) : (render json: { error: 'job not found' }, status: 404)
  end

  def get_template_details
    job_template = YAML.load_file("#{Rails.root.to_s}/config/job_template.yml")
    template_details = job_template['template'][params['template_name']]
    if template_details
      render json: { success: true, template_details: template_details}, status: :ok
    else
      render json: { success: false, error: 'template not found'}, status: 404
    end
  end

  def jobs_by_user
    # ***************************************************

  #   PayPal::SDK::REST.set_config(
  #     :mode => "sandbox", # "sandbox" or "live"
  #     :client_id => ENV["PAYPAL_CLIENT_ID"],
  #     :client_secret => ENV["PAYPAL_CLIENT_SECRET"]
  #   )

  #   payment = Payment.new({
  # :intent =>  "sale",
  # :payer =>  {
  #   :payment_method =>  "paypal" },
  # :redirect_urls => {
  #   :return_url => "http://localhost:3000/payment/execute",
  #   :cancel_url => "http://localhost:3000/" },
  # :transactions =>  [{
  #   :item_list => {
  #     :items => [{
  #       :name => "item",
  #       :sku => "item",
  #       :price => "5",
  #       :currency => "USD",
  #       :quantity => 1 }]},
  #   :amount =>  {
  #     :total =>  "5",
  #     :currency =>  "USD" },
  #   :description =>  "This is the payment transaction description." }]})

  #   if payment.create
  #     order.token = payment.token
  #     order.charge_id = payment.id
  #     return payment.token if order.save
  #   end

    # ***************************************************
    jobs = @current_user.jobs.all.order(created_at: :desc)
    if jobs
      render json: jobs, each_serializer: JobSerializer
    else
      render json: { error: 'jobs not found' }, status: 404
    end
  end

  def get_all_jobs
    jobs = Job.search(params[:search]).results if params[:search].present?
    if jobs.present?
      jobs = jobs.select{|job| job.job_visibility == "Anyone"}
    else
      jobs = Job.public_data.order(created_at: :desc)
    end
    jobs.present? ? (render json: jobs, each_serializer: JobSerializer) : (render json: [], status: :ok)
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
      freelancer_users = freelancer_users.results.select{|fu| (fu.role == "freelancer" && fu.account_approved == true && fu.professional_profile_created == true && !@job.invites.pluck(:recipient_id).include?(fu.id) && !@job.contracts.pluck(:freelancer_id).include?(fu.id) && !((@job.job_category.split(',')&(fu.profile.category.split(',')))).empty? )}
    else
      freelancer_users = User.search("#{@job.job_category} #{@job.job_speciality}", operator: "or", fields: [:user_skill, :user_category])       
      freelancer_users = freelancer_users.results.select{|fu| (fu.role == "freelancer" && fu.account_approved == true && fu.professional_profile_created == true && !@job.invites.pluck(:recipient_id).include?(fu.id) && !@job.contracts.pluck(:freelancer_id).include?(fu.id) )}     
    end
    if freelancer_users.present?
      favorited_freelancers = @current_user.favorites_freelancers.pluck(:id) rescue []
      render json: freelancer_users, each_serializer: FreelancerSerializer, favorited_freelancers: favorited_freelancers, status: :ok
    else
      render json: [], status: :ok
    end
  end

  def invited_freelancer
    invited_freelancers = User.where(id: @job.invites.pluck(:recipient_id))
    if invited_freelancers.present?
      invited_freelancers = invited_freelancers.select{|freelancer| (!@job.contracts.pluck(:freelancer_id).include?(freelancer.id))} 
      favorited_freelancers = @current_user.favorites_freelancers.pluck(:id) rescue []
      render json: invited_freelancers, each_serializer: FreelancerSerializer, favorited_freelancers: favorited_freelancers, status: :ok
    else
      render json: [], status: :ok
    end
  end

  def hired_freelancer
    hired_freelancers = User.where(id: @job.contracts.pluck(:freelancer_id))
    if hired_freelancers.present?
      favorited_freelancers = @current_user.favorites_freelancers.pluck(:id) rescue []
      render json: hired_freelancers, each_serializer: FreelancerSerializer, favorited_freelancers: favorited_freelancers, status: :ok
    else
      render json: [], status: :ok
    end
  end

  def get_all_hired_freelancers
    hired_freelancers = User.where(id: @current_user.contracts.pluck(:freelancer_id))
    if hired_freelancers.present?
      favorited_freelancers = @current_user.favorites_freelancers.pluck(:id) rescue []
      render json: hired_freelancers, each_serializer: FreelancerSerializer, favorited_freelancers: favorited_freelancers, status: :ok
    else
      render json: [], status: :ok
    end
  end

  def get_job_proposals
    job_proposals = @job.job_applications.present? ? @job.job_applications : []
    render json: job_proposals, each_serializer: JobProposalSerializer, include: ['user.profile'], status: :ok
  end

  def get_job_active_contract
    active_job_contract_freelancers = @job.contracts.present? ? @job.contracts.active_contract.pluck(:freelancer_id) : []
    freelancers = User.where(id: active_job_contract_freelancers)
    if freelancers.present?
      render json: freelancers, each_serializer: FreelancerSerializer, status: :ok
    else
      []
    end
  end

  def destroy
    if @job.destroy
      render json: {success: true, message: "Job post removed", status: 200} 
    end
  end

	private

  def find_job
    @job = Job.where(uuid: params[:id]).first
    @job = Job.where(id: params[:id]).first if @job.blank?
    render_error("Not found", 404) unless @job
  end

  def job_params
    params.require(:job).permit(:job_title, :job_category , :job_speciality, :job_description,:job_document,:job_type,:job_api_integration,:job_expertise_required,:job_additional_expertise_required , :job_visibility,:number_of_freelancer_required,:job_pay_type, :job_pay_value, :job_experience_level,:job_duration,:job_time_requirement,job_screening_questions_attributes: [:id, :job_question_label,:job_question], job_qualifications_attributes:  [:id, :english_level, :location, :certificate_category, :qualification_group])
  end
end
