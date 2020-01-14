class Api::V1::ContractController < Api::V1::ApiController
  include Api::V1::Concerns::Notify
  before_action :authorize_request
  before_action :set_contract, only: [:show, :update]
  
  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      notify_user(@current_user.id, @contract.freelancer_id, @contract.uuid, "Job offer", "You have received an offer for the job \"#{@contract.title}\" ")
# ***********************************************************************************
      payment = @contract.payments.build
      payment.payment_mode = "paypal"
      payment.order_id = params[:pay_data][:orderID]
      payment.payer_id = params[:pay_data][:payerID]  
      payment.amount = params[:pay_details][:purchase_units][0][:payments][:captures][0][:amount][:value]
      payment.payee_id = params[:pay_details]['purchase_units'][0]['payee']['merchant_id']
      payment.intent = params[:pay_details][:intent]
      payment.status = params[:pay_details][:status]
      payment.capture_id = params[:pay_details]['purchase_units'][0]['payments']['captures'][0]['id']
      payment.save!

# ***********************************************************************************
      render json: {succes: true, status: 200}
    else
      render_error("Something went wrong....!", 404)
    end
  end

  def show
    if @contract.present?
      render json: @contract, serializer: ContractSerializer  
    else
      render json: { error: 'job not found' }, status: 404
    end 
  end

  def update
    if @contract.update(contract_params)
      @contract.status_updated_at = Time.now
      @contract.save!
      notify_user(@contract.freelancer_id, @contract.hired_by_id, "Offer update", "Your offer \"#{@contract.title}\" was #{@contract.status.downcase} ")
      
      if contract_params[:status] == "Accepted"
        @contract.job.update(:job_status => "active")
      end

      render json: { success: true, message: "Offer updated successfully...!", status: 200 }
    else
      render_error(@contract.errors.full_messages, 422)
    end
  end

  def manager_active_contracts
    offers = @current_user.contracts.active_contract.present? ? @current_user.contracts.active_contract.order(created_at: :desc) : []
    render json: offers, each_serializer: FreelancerOfferSerializer, status: :ok
  end
  
  private

  def contract_params
    params.require(:contract).permit(:job_id, :title, :payment_mode,  :hourly_rate, :time_period, :time_period_limit, :start_date, :weekly_payment, :description, :attachment, :fixed_price_mode, :fixed_price_amount, :hired_by_id, :freelancer_id, :status, milestones_attributes:  [:description, :due_date, :deposite_amount])
  end

  def set_contract
    @contract = Contract.find_by_uuid(params[:id])
  end

end
