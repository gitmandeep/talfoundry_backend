class RequestedPayment < ApplicationRecord
	belongs_to :user
	belongs_to :contract, optional: true
	belongs_to :milestone, optional: true
end
