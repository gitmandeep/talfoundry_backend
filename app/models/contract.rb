class Contract < ApplicationRecord
  belongs_to :job
  belongs_to :freelancer, :class_name => 'User'
  belongs_to :hiring_manager, :class_name => 'User'

  mount_base64_uploader :attachment, ContractUploader
  before_save :set_contract_id

  def set_contract_id
  	self.contract_uniq_id = sprintf('%010d', rand(10**10))
  end
end
