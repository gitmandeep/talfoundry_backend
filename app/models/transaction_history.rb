class TransactionHistory < ApplicationRecord
  belongs_to :manager, class_name: "User"
  belongs_to :freelancer, class_name: "User"
  belongs_to :contract, optional: true
  belongs_to :milestone, optional: true

  def refund_payment
    sale = PayPal::SDK::REST::Sale.find(capture_id)
    refund = sale.refund({
      :amount => {
        :total => amount,
        :currency => "USD"
      }
    })
    self.refund_id = refund.refund_id
    self.save!
  end
end