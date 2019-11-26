class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :title
  attribute :sender
  has_many :messages

  def sender
  	@object.sender
  end

  def receiver
	@object.recipient
  end
end
