class UserSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :email, :first_name, :last_name, :role, :profile_created, :image_url, :image_base64, :call_schedule, :account_approved, :professional_profile_created, :user_profile, :full_name, :country, :country_id, :created_at
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

  def image_url
    object.image.try(:url)
  end

  def image_base64
    if object.role != "admin"
      img = open(object.image.try(:url)) rescue ''
      img_base64 = Base64.encode64(img.read) rescue ''
    else
      ''
    end
  end
end
