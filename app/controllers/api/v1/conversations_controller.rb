class Api::V1::ConversationsController < Api::V1::ApiController
  before_action :authorize_request
  
  def index
    #conversations = current_user.conversations
    conversations = Conversation.where(sender_id: current_user.id).or(Conversation.where(recipient_id: current_user.id)).order(updated_at: :desc)
    conversations.present? ? (render json: conversations, each_serializer: ConversationSerializer) : []
  end

  def create
    # conversation = Conversation.get(current_user.id, params[:user_id])
    # if conversation
    #   conversation = Conversation.new(conversation_params)

    #   if conversation.save
    #     serialized_data = ActiveModelSerializers::Adapter::Json.new(
    #       ConversationSerializer.new(conversation)
    #     ).serializable_hash
    #     ActionCable.server.broadcast 'conversations_channel', serialized_data
    #     head :ok
    #   end
    # end

    @conversation = Conversation.get(current_user.id, params[:conversation][:recipient_id] )
    if @conversation.present?
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        ConversationSerializer.new(@conversation)
      ).serializable_hash
      ActionCable.server.broadcast 'conversations_channel', serialized_data
      head :ok
    end
  end

  def update
    conversation = Conversation.find(params[:id])
    if conversation.present?
      conversation.try(:messages).unread.update_all(read_at: Time.now)
      render json: {succes: true, status: 200}
    end
  end

  def search_conversation
    users = User.search(params[:search]).results.pluck(:id)
    if current_user.is_hiring_manager?
      @conversations = Conversation.joins(:sender).where(sender_id: current_user.id, recipient_id: users)
    elsif current_user.is_freelancer?
      @conversations = Conversation.joins(:recipient).where(recipient_id: current_user.id, sender_id: users)
    end
      @conversations.present? ? (render json: @conversations, each_serializer: ConversationSerializer) : []
  end
  
  private
  
  def conversation_params
    params.require(:conversation).permit(:title, :sender_id, :recipient_id)
  end

end
