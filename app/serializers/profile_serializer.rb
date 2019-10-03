class ProfileSerializer < ActiveModel::Serializer
  attributes :id
	attributes :profile_picture
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

  has_many :educations, serializer: EducationSerializer
	has_many :employments, serializer: EmploymentSerializer
	has_many :certifications, serializer: CertificationSerializer

	def skill
		object.skill.try(:split, (','))
	end

end
