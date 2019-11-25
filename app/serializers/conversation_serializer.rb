class ConversationSerializer < ActiveModel::Serializer
  attributes :id
  attributes :title
  has_many :messages
end
