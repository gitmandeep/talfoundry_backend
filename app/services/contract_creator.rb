class ContractCreator
	def initialize(contract, transaction_history)
		@contract = contract
		@transaction_history = transaction_history
	end

	def create
		Contract.transaction do
			begin
				if @contract.save!
					@contract.reload
					@transaction_history.contract_id = @contract.id
					if @contract.milestones.present?
						@transaction_history.milestone_id = @contract.milestones.first.id
					end
					@transaction_history.manager_id = @contract.hired_by_id
					@transaction_history.freelancer_id = @contract.freelancer_id
					@transaction_history.payment_mode = "paypal"
					@transaction_history.transaction_type = "Offer creation"
					@transaction_history.payment_type = "credited"
					@transaction_history.save!
					true
				else
					render_error("Something went wrong....!", 404)
				end
			rescue StandardError => e
				raise ActiveRecord::Rollback
				return false
			end
		end
	end
end
