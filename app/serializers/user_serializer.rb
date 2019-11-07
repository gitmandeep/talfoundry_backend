class UserSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
	attributes :email
  attributes :first_name
  attributes :last_name
  attributes :role
  attributes :profile_created
  attributes :call_schedule
  attributes :account_approved
  attributes :professional_profile_created
  attributes :user_profile
	attributes :full_name
  attributes :country
	attributes :created_at


  #has_one :profile, serializer: ProfileSerializer


  def full_name
  	object.first_name + " " + object.last_name
  end

  def user_profile
    if object.role == "freelancer"
      user_profile_details = []
      profile_picture = object.profile ? object.profile.profile_picture.try(:url) : ""
      profile_uuid = object.profile ? object.profile.uuid : ""
      user_profile_details << profile_picture
      user_profile_details << profile_uuid
    end
  end
end
