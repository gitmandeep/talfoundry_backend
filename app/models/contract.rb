class Contract < ApplicationRecord
  belongs_to :job
  belongs_to :freelancer, :class_name => 'User'
  belongs_to :hired_by, :class_name => 'User'

  mount_base64_uploader :attachment, ContractUploader
  before_create :set_contract_id


	scope :pending_offer, -> { where({ status: "Pending"}) }
  scope :active_offer, -> { where({ status: "Accepted"}) }


  

  def set_contract_id
  	self.contract_uniq_id = sprintf('%010d', rand(10**10))
  	self.status = "Pending"
  end
end
