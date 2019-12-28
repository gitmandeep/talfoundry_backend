class FreelancerSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :email, :full_name, :user_picture, :profile_created, :call_schedule, :account_approved, :account_active, :created_at, :freelancer_employments, :profile_uuid, :favorited_freelancer, :payment_method
  has_one :profile, serializer: ProfileSerializer

  def full_name
    full_name = object.first_name + " " + object.last_name
    if object.profile.try(:search_engine_privacy).present?
      display_name = object.profile.try(:search_engine_privacy) == "Show my full name" ? full_name : object.first_name + " " + object.last_name.chr
    else
      display_name = full_name
    end
     return display_name 
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

  def favorited_freelancer
    if @instance_options[:favorited_freelancers].present?
      return @instance_options[:favorited_freelancers].include? object.id
    else
      return false 
    end
  end

  def payment_method
    current_user.try(:payment_methods).where(account_type: 'paypal')
    # if billing_method.present?
    #   PaymentMethodSerializer.new(billing_method.first)
    # end
  end
end
