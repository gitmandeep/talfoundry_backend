class Api::V1::ConversationsController < Api::V1::ApiController
	 def index
    conversations = Conversation.all
    render json: conversations
  end

  def create
    @conversation = Conversation.get(current_user.id, params[:user_id])
  
    if @conversation.present
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        ConversationSerializer.new(@conversation)
      ).serializable_hash
      ActionCable.server.broadcast 'conversations_channel', serialized_data
      head :ok
    end
  end
  
  # private
  
  # def conversation_params
  #   params.require(:conversation).permit(:title)
  # end
end
