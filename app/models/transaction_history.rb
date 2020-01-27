class TransactionHistory < ApplicationRecord
  belongs_to :manager, class_name: "User"
  belongs_to :freelancer, class_name: "User"
  belongs_to :contract, optional: true
  belongs_to :milestone, optional: true

  def refund_payment(last_balance)
    sale = PayPal::SDK::REST::Sale.find(capture_id)
    refund = sale.refund({
      :amount => {
        :total => amount,
        :currency => "USD"
      }
    })
    transaction = TransactionHistory.new
    transaction.manager_id = self.manager_id
    transaction.freelancer_id = self.freelancer_id
    transaction.payment_mode = "paypal"
    transaction.contract_id = self.contract_id
    transaction.transaction_type = "Offer declined"
    transaction.payment_type = "debited"
    transaction.order_id = self.order_id
    transaction.payer_id = self.payer_id
    transaction.amount = self.amount
    transaction.balance = last_balance - self.amount
    # transaction.balance = (last_balance ? last_balance : 0) + transaction.amount
    transaction.payee_id = self.payee_id
    transaction.status = refund.try(:status)
    transaction.capture_id = self.capture_id
    transaction.refund_id = refund.id

    transaction.save!
  end
end
