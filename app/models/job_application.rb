class JobApplication < ApplicationRecord
	mount_base64_uploader :document, JobApplicationDocumentUploader

	belongs_to :user
	belongs_to :job
	has_many :job_application_answers, :dependent => :destroy
	accepts_nested_attributes_for :job_application_answers
end
