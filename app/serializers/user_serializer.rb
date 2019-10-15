class UserSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
	attributes :email
	attributes :full_name
	#attributes :user_picture
	attributes :profile_created
	attributes :account_approved
	attributes :created_at


  has_one :profile, serializer: ProfileSerializer


  def full_name
  	object.first_name + " " + object.last_name
  end

  # def user_picture
  #   if object.profile_created
  # 	 object.profile.profile_picture.try(:url)
  #   end
  # end
  
end
