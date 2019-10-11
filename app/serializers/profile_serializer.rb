class ProfileSerializer < ActiveModel::Serializer
  attributes :id
	attributes :profile_picture
	attributes :profile_picture_base64
	attributes :current_job_title
	attributes :current_location_country
	attributes :current_location_city
	attributes :professional_title
	attributes :professional_overview
	attributes :skill
	attributes :youtube_video_link
	attributes :hourly_rate
	attributes :availability
	attributes :english_proficiency
	attributes :about_me
	attributes :development_experience
  
  has_many :educations, serializer: EducationSerializer
	has_many :employments, serializer: EmploymentSerializer
	has_many :certifications, serializer: CertificationSerializer

	
	def profile_picture
		object.profile_picture.try(:url)
	end

	def profile_picture_base64
		img = open(object.profile_picture.try(:url))
		img_base64 = Base64.encode64(img.read)
	end

	def skill
		object.skill.try(:split, (','))
	end

end
