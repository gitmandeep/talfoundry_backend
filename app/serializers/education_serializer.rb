class EducationSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :school, :from_date, :to_date, :degree, :area_of_study, :education_description
end
