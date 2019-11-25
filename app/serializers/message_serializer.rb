class MessageSerializer < ActiveModel::Serializer
  attributes :id
  attributes :user_id
  attributes :conversation_id
  attributes :text
  attributes :created_at
end
