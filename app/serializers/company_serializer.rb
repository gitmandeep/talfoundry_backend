class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url, :image_base64, :owner, :phone, :vat_id, :time_zone, :address

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
