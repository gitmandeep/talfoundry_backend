class ContractSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
	attributes :title
	attributes :payment_mode
	attributes :hourly_rate
	attributes :time_period
	attributes :time_period_limit
	attributes :start_date
	attributes :weekly_payment
	attributes :description
	attributes :attachment
	attributes :status
	attributes :fixed_price_mode
	attributes :fixed_price_amount
	attributes :hired_by_id
	attributes :freelancer_id
	attributes :created_at

	has_one :job, serializer: JobSerializer

	def attachment
		object.attachment.try(:url)
	end
end