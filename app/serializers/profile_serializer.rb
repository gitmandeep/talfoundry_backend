class ProfileSerializer < ActiveModel::Serializer
  attributes :id
	attributes :profile_picture
	attributes :professional_title
	attributes :professional_overview
	attributes :skill
	attributes :youtube_video_link
	attributes :hourly_rate
	attributes :availability

  has_many :educations, serializer: EducationSerializer
	has_many :employments, serializer: EmploymentSerializer
end
