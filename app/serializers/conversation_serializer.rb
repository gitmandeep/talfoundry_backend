class ConversationSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :title 
  attribute :created_at
  attribute :sender
  attribute :sender_picture
  attribute :receiver
  attribute :receiver_picture

  has_many :messages

  def sender
  	@object.sender
  end

  def receiver
	  @object.recipient
  end

  def sender_picture
    @object.sender.profile ? @object.sender.profile.try(:profile_picture).try(:url)  : ''
  end

  def receiver_picture
    @object.recipient.profile ? @object.recipient.profile.try(:profile_picture).try(:url)  : ''
  end
end
