class Profile < ApplicationRecord
	mount_base64_uploader :profile_picture, AvatarUploader
	mount_base64_uploader :resume, AvatarUploader

  belongs_to :user
	has_many :educations, :dependent => :destroy
	accepts_nested_attributes_for :educations
	
	has_many :employments, :dependent => :destroy
	accepts_nested_attributes_for :employments
	

	has_many :certifications, :dependent => :destroy
	accepts_nested_attributes_for :certifications

  validates :profile_picture , :resume , :current_location_country , :current_location_city , :citizenship_country , :citizenship_full_name, presence: true
  validates :current_company_name , :current_job_title , :about_me , :worked_as_freelancer , :freelancing_pros_cons , presence: true

end
