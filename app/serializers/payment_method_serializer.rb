class PaymentMethodSerializer < ActiveModel::Serializer
	attributes :id, :user_account_id, :name, :email, :account_type, :verified
end
