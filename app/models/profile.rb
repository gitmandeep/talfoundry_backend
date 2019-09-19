class Profile < ApplicationRecord
	mount_base64_uploader :profile_picture, AvatarUploader
	mount_base64_uploader :resume, AvatarUploader

  belongs_to :user

  validates :profile_picture , :resume , :current_location_country , :current_location_city , :citizenship_country , :citizenship_full_name, presence: true
  validates :current_company_name , :current_job_title , :about_me , :worked_as_freelancer , :freelancing_pros_cons , presence: true

end
