class Job < ApplicationRecord
	mount_base64_uploader :job_document, AvatarUploader


	has_many :job_screening_questions, :dependent => :destroy
	has_many :job_qualifications, :dependent => :destroy

  validates :job_title,:job_category, :job_description, :job_type, :job_expertise_required,  presence: true
  validates :job_visibility,:number_of_freelancer_required,:job_pay_type,:job_experience_level,:job_duration,:job_time_requirement, presence: true

end
