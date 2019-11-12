class FreelancerSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :email, :full_name, :user_picture, :profile_created, :call_schedule, :account_approved, :account_active, :created_at, :freelancer_employments, :profile_uuid
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
