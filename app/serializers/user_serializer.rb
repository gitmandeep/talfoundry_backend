class UserSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :email, :first_name, :last_name, :role, :profile_created, :call_schedule, :account_approved, :professional_profile_created, :user_profile, :full_name, :country, :country_id, :created_at
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
