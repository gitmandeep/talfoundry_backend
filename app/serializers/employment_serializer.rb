class EmploymentSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :company_name, :country, :state, :city, :title, :role, :period_month_from, :period_year_from, :period_month_to, :period_year_to
end
