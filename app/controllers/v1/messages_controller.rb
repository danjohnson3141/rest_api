module V1
  class MessagesController < ApplicationController

    before_action :allow_messages

    # GET /messages
    # list of users you have had message encounters with
    def index
      raise ApiAccessEvanta::PermissionDenied unless AppSettings::Value.new(:messages, user: current_user).on?
      @messages = Message.get_message_list(current_user)
      render json: @messages
    end

    # GET /messages/conversation/:user_id
    # list messages you have had with another user
    # Needs to mark all messages as read
    def conversation
      @messages = Message.get_conversation(current_user, params[:user_id])
      render json: @messages, each_serializer: MessageConversationSerializer
    end

    # POST /messages
    def create
      @message = Message.new(post_message_params)
      raise ApiAccessEvanta::Unprocessable if @message.recipient_user_id.nil?
      raise ActiveRecord::RecordNotFound if @message.recipient_user.nil?
      raise ApiAccessEvanta::PermissionDenied unless current_user.can_send_message_to?(@message.recipient_user)
      @message.sender_user_id = current_user.id
      if @message.save    
        render json: @message, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end

    # DELETE /messages/:message_id
    def archive
      message = Message.find(params[:message_id])
      message.archive(current_user)
      head :no_content
    end

    # DELETE /messages/conversation/:user_id
    def archive_conversation
      Message.get_conversation(current_user, params[:user_id]).each do |message|
        message.archive(current_user)
      end
      head :no_content
    end

    private

      # Never trust parameters from the scary internet, only allow the white list through.
      def post_message_params
        params.require(:message).permit(:body, :recipient_user_id)
      end

      def allow_messages
        raise ApiAccessEvanta::PermissionDenied unless AppSettings::Value.new(:messages, user: current_user).on?
      end

  end

end