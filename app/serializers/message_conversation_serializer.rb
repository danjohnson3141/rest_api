class MessageConversationSerializer < ActiveModel::Serializer

  attributes :id, :unread, :viewed_date, :body, :sender_user_id, :recipient_user_id, :created_at, :ago

  def unread
    if scope.id == object.recipient_user_id
      if object.viewed_date.nil?
        return true
      end
    end
    false
  end
  
end
