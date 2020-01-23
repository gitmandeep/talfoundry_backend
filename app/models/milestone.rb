class Milestone < ApplicationRecord
  belongs_to :contract
  has_many :transaction_histories, dependent: :destroy
  has_many :requested_payments, dependent: :destroy
end
