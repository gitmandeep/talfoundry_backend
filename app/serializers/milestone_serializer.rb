class MilestoneSerializer < ActiveModel::Serializer
	attributes :id
	attributes :uuid
	attributes :description
	attributes :due_date
	attributes :deposite_amount
end