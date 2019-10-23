class FreelancerSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
	attributes :email
	attributes :full_name
	attributes :user_picture
	attributes :profile_created
  attributes :call_schedule
	attributes :account_approved
	attributes :account_active
	attributes :created_at
	attributes :freelancer_employments
	attributes :profile_uuid


  has_one :profile, serializer: ProfileSerializer


  def full_name
  	object.first_name + " " + object.last_name
  end

	def freelancer_employments
		object.profile.try(:employments)
	end

  def user_picture
    if object.profile_created
  	 object.profile.try(:profile_picture).try(:url)
    end
  end

  def profile_uuid
  	uuid = object.profile ? object.try(:profile).try(:uuid) : ""
  	return uuid
  end

end
