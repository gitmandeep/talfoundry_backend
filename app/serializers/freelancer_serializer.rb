class FreelancerSerializer < ActiveModel::Serializer
  attributes :id
	attributes :email
	attributes :full_name
	attributes :user_picture
	attributes :profile_created
	attributes :account_approved
	attributes :created_at
	attributes :freelancer_educations
	attributes :freelancer_employments


  has_one :profile, serializer: ProfileSerializer


  def full_name
  	object.first_name + " " + object.last_name
  end

  def freelancer_educations
		object.profile.try(:educations)
	end

	def freelancer_employments
		object.profile.try(:educations)
	end

  def user_picture
    if object.profile_created
  	 object.profile.profile_picture.try(:url)
    end
  end
  
end
