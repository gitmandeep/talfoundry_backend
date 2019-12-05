class CompanySerializer < ActiveModel::Serializer
	attributes :id, :name, :image_url, :owner, :phone, :vat_id, :time_zone, :address

	def image_url
		object.image.try(:url)
	end
end
