class Job < ApplicationRecord 	
	searchkick

	mount_base64_uploader :job_document, JobDocumentUploader

  #before_save :set_array_data

  belongs_to :user
	has_many :job_screening_questions, :dependent => :destroy
	accepts_nested_attributes_for :job_screening_questions
	has_many :job_qualifications, :dependent => :destroy
	accepts_nested_attributes_for :job_qualifications
  has_many :invites, :dependent => :destroy
  has_many :job_applications, :dependent => :destroy
  has_many :contracts, :dependent => :destroy
  	
  validates :job_title,:job_category, :job_description, :job_type, presence: true
  validates :job_visibility,:number_of_freelancer_required,:job_pay_type,:job_experience_level,:job_duration,:job_time_requirement, presence: true

  scope :recent, -> {where(["job_visibility = ? and created_at >= ?", "Anyone", 30.day.ago]).order(created_at: :desc)}
  scope :newest, lambda {where("created_at > ?", 10.days.ago)}
  scope :public_data, -> {where(job_visibility: "Anyone")}

  def search_data
    {
      job_title: job_title,
      job_description: job_description,
      job_additional_expertise_required: job_additional_expertise_required,
      job_category: job_category,
      job_pay_type: job_pay_type,
      job_experience_level: job_experience_level,
      location: self.job_qualifications.first.try(:location),
      job_duration: job_duration,
      job_time_requirement: job_time_requirement
    }
  end

  # def set_array_data
  #   self.job_category = eval(job_category).try(:join, (',')) rescue ''
  #   self.job_speciality = eval(job_speciality).try(:join, (',')) rescue ''
  #   self.job_expertise_required = eval(job_expertise_required).try(:join, (',')) rescue ''
  #   self.job_additional_expertise_required = eval(job_additional_expertise_required).try(:join, (',')) rescue ''
  # end

end
