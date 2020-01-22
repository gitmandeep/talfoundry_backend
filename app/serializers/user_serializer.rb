class UserSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :email, :first_name, :last_name, :role, :profile_created, :image_url, :call_schedule, :account_approved, :professional_profile_created, :user_profile, :full_name, :country, :country_id, :created_at, :is_security_qus_added
  #has_one :profile, serializer: ProfileSerializer

  def full_name
    full_name = object.first_name + " " + object.last_name
    if object.profile.try(:search_engine_privacy).present?
      display_name = object.profile.try(:search_engine_privacy) == "Show my full name" ? full_name : object.first_name + " " + object.last_name.chr
    else
      display_name = full_name
    end
     return display_name 
  end

  def user_profile
    user_profile_details = {}
    if object.is_freelancer?
      profile_picture = object.profile ? object.profile.profile_picture.try(:url) : ""
      profile_uuid = object.profile ? object.profile.uuid : ""
      user_profile_details['freelancer_image'] = profile_picture
      user_profile_details['freelancer_uuid'] = profile_uuid
    end
    return user_profile_details
  end

  def image_url
    object.image.try(:url)
  end

  def is_security_qus_added
    object.security_questions.present?
  end

end
