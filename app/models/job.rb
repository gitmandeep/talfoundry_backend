class Job < ApplicationRecord 	
	searchkick

	mount_base64_uploader :job_document, AvatarUploader

  belongs_to :user
	has_many :job_screening_questions, :dependent => :destroy
	accepts_nested_attributes_for :job_screening_questions
	has_many :job_qualifications, :dependent => :destroy
	accepts_nested_attributes_for :job_qualifications

	# scope: newest_first, -> { order(created_at: :desc) }
	
  validates :job_title,:job_category, :job_description, :job_type, :job_expertise_required,  presence: true
  validates :job_visibility,:number_of_freelancer_required,:job_pay_type,:job_experience_level,:job_duration,:job_time_requirement, presence: true

   def search_data
    {
      job_title: job_title,
      job_description: job_description
    }
  end

end
