class Api::V1::ContractController < Api::V1::ApiController
  before_action :authorize_request
  # before_action :set_contract
  
  def create
    if Contract.create(params[:contract_params])
      render json: {succes: true, status: 200}
    else
      render_error("Something went wrong....!", 404)
    end
  end
  
  private

  def contract_params
    params.require(:contract).permit(:title, :description, :attachment)
  end

end
