class MessageSerializer < ActiveModel::Serializer
	attribute :id
	attribute :user_id
	attribute :conversation_id
	attribute :text
	attribute :created_at
        attribute :read_at
end
