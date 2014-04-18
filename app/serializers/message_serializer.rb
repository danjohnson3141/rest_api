class MessageSerializer < ActiveModel::Serializer
  has_one :user, serializer: UserShortSerializer

  attributes :id, :unread, :viewed_date, :body, :sender_user_id, :recipient_user_id, :created_at, :ago

  def unread
    if scope.id == object.recipient_user_id
      if object.viewed_date.nil?
        return true
      end
    end
    false
  end

  # Shows the other user who is not you
  def user
    if scope.id == object.sender_user_id
      object.recipient_user
    else
      object.sender_user
    end
  end

end
