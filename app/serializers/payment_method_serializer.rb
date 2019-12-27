class PaymentMethodSerializer < ActiveModel::Serializer
	attributes :id, :user_account_id, :name, :email, :account_type, :verified

	def verified
		if object.account_type == "paypal"
			return object.verified.present? ? "Active" : "Inactive"
		end
	end
end
