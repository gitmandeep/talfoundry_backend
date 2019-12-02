class Company < ApplicationRecord
	mount_base64_uploader :image, CompanyImageUploader

	belongs_to :user
end
