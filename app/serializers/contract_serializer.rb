class ContractSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :title, :contract_uniq_id, :payment_mode, :hourly_rate, :time_period, :time_period_limit, :start_date, :weekly_payment, :description, :attachment, :fixed_price_mode, :fixed_price_amount, :hired_by_id, :freelancer_id, :created_at, :status_updated_at
  attributes :status
  attributes :job_uuid
  attributes :job_title
  attributes :job_category
  attributes :job_description
  attributes :freelacer_name
  attributes :freelacer_picture
  attributes :proposal_id
  has_one :hired_by, serializer: ProjectManagerSerializer
  has_one :freelancer, serializer: FreelancerSerializer
  has_many :milestones, serializer: MilestoneSerializer
  has_many :transaction_histories, serializer: TransactionHistorySerializer
  #has_one :job, serializer: JobSerializer

  def attachment
    object.attachment.try(:url)
  end

  def job_uuid
    object.job.try(:uuid)
  end

  def job_title
    object.job.try(:job_title)
  end

  def job_category
    object.job.try(:job_category)
  end

  def job_description
    object.job.try(:job_description)
  end

  def freelacer_name
    object.try(:freelancer).try(:display_full_name)
  end

  def freelacer_picture
    object.try(:freelancer).try(:profile) ? object.freelancer.profile.profile_picture.try(:url) : ""
  end

  def proposal_id
    proposals = object.freelancer.try(:job_applications)
    if proposals.present?
      proposals.each do |proposal|
        if proposal.job_id == object.job_id
          @proposal_uuid = proposal.uuid
        end
      end
    end
    return @proposal_uuid || ''
  end
end
