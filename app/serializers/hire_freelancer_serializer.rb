class HireFreelancerSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :full_name
  attributes :user_picture
  attributes :user_rate
  attributes :job_id
  # has_one :profile, serializer: ProfileSerializer

  def full_name
    object.first_name + " " + object.last_name
  end


  def user_picture
    if object.profile_created
      object.profile.try(:profile_picture).try(:url)
    end
  end

  def user_rate
    if object.professional_profile_created
      object.profile.try(:hourly_rate)
    end
  end

  def job_id
    @instance_options[:job_id]
  end
end
