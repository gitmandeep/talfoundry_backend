class MilestoneSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :description, :due_date, :deposite_amount, :payment_requested?

	def payment_requested?
		object.try(:requested_payments)
	end
end