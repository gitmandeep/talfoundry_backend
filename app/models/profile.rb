class Profile < ApplicationRecord
	mount_base64_uploader :profile_picture, ProfileDocumentUploader
	mount_base64_uploader :resume, ProfileDocumentUploader

	before_create :skill_set
	before_create	:category_set
	before_create :certification_set

  belongs_to :user
	has_many :educations, :dependent => :destroy
	accepts_nested_attributes_for :educations
	
	has_many :employments, :dependent => :destroy
	accepts_nested_attributes_for :employments
	

	has_many :certifications, :dependent => :destroy
	accepts_nested_attributes_for :certifications

  validates :profile_picture , :resume , :current_location_country , :current_location_city , :citizenship_country , :citizenship_full_name, presence: true
  validates :current_company_name , :current_job_title , :about_me , :worked_as_freelancer, presence: true


  def skill_set
    self.skill = eval(skill).try(:join, (','))
  end

  def category_set
    self.category = eval(category).try(:join, (','))
  end

  def certification_set
    self.certification = eval(certification).try(:join, (','))
  end

end
