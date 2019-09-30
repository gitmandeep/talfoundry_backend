class EmploymentSerializer < ActiveModel::Serializer
  attributes :id
 	attributes :company_name
 	attributes :country
 	attributes :state
 	attributes :city
 	attributes :title
 	attributes :role
 	attributes :period_month_from
 	attributes :period_year_from
 	attributes :period_month_to
 	attributes :period_year_to
end
