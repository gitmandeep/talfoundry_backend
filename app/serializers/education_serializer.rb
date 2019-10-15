class EducationSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :school
	attributes :from_date
	attributes :to_date
	attributes :degree
	attributes :area_of_study
	attributes :education_description
end
