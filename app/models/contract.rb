class Contract < ApplicationRecord
  belongs_to :job
  belongs_to :freelancer, :class_name => 'User'
  belongs_to :hired_by, :class_name => 'User'
  has_many   :milestones, :dependent => :destroy
  accepts_nested_attributes_for :milestones
  has_many :transaction_histories, :dependent => :destroy
  has_many :requested_payments, dependent: :destroy

  mount_base64_uploader :attachment, ContractUploader
  before_create :set_contract_id

  scope :pending_offer, -> { where({ status: "Pending"}) }
  scope :active_contract, -> { where({ status: "Accepted"}) }

  def set_contract_id
    self.contract_uniq_id = sprintf('%010d', rand(10**10))
    self.status = "Pending"
  end
end
