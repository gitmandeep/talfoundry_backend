class CompanySerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
 	attributes :name
 	attributes :image_url
 	attributes :image_base64
 	attributes :owner
 	attributes :phone
 	attributes :vat_id
 	attributes :role
 	attributes :time_zone
 	attributes :address


	def image_url
		object.image.try(:url)
	end

	def image_base64
		if current_user.role != "admin"
			img = open(object.image.try(:url)) rescue ''
			img_base64 = Base64.encode64(img.read) rescue ''
		else
			''
		end
	end
end