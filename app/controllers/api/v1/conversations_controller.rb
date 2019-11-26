class Api::V1::ConversationsController < Api::V1::ApiController
	 def index
    conversations = Conversation.all #current_user.conversations
    #conversations = Conversation.where(sender_id: current_user.id).or(Conversation.where(recipient_id: current_user.id))
    render json: conversations, each_serializer: ConversationSerializer
  end

  def create
    conversation = Conversation.new(conversation_params)
    conversation.sender_id = User.first.id
    conversation.recipient_id = User.last.id

    if conversation.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        ConversationSerializer.new(conversation)
      ).serializable_hash
      ActionCable.server.broadcast 'conversations_channel', serialized_data
      head :ok
    end

    # @conversation = Conversation.get(current_user.id, params[:user_id])
  
    # if @conversation.present
    #   serialized_data = ActiveModelSerializers::Adapter::Json.new(
    #     ConversationSerializer.new(@conversation)
    #   ).serializable_hash
    #   ActionCable.server.broadcast 'conversations_channel', serialized_data
    #   head :ok
    # end
  end
  
  # private
  
  def conversation_params
    params.require(:conversation).permit(:title)
  end
end
