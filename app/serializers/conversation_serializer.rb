class ConversationSerializer < ActiveModel::Serializer
  attribute :id
  attribute :uuid
  attribute :title 
  attribute :created_at
  attribute :sender
  #attribute :sender_picture
  attribute :receiver
  #attribute :receiver_picture
  
  has_many :messages

  def sender
  	@sender = @object.sender
    @sender.user_name = @sender.image.try(:url)
    return @sender
  end

  def receiver
    @receiver = User.where(id: @object.recipient).first
    if @receiver
      @receiver.user_name = @receiver.profile ? @receiver.profile.try(:profile_picture).try(:url)  : ''
      return @receiver
    end
  end


  # def sender_picture
  #   @object.sender.profile ? @object.sender.profile.try(:profile_picture).try(:url)  : ''
  # end

  # def receiver_picture
  #   @object.recipient.profile ? @object.recipient.profile.try(:profile_picture).try(:url)  : ''
  # end
end
