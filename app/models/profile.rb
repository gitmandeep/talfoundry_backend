class Profile < ApplicationRecord
	mount_uploader :profile_picture, :resume, AvatarUploader
	#mount_uploader :resume, AvatarUploader

  belongs_to :user, :dependent => :destroy
end
