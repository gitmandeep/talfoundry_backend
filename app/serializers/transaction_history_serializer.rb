class TransactionHistorySerializer < ActiveModel::Serializer
  attributes :id, :payment_mode, :contract_id, :order_id, :payer_id, :amount
end