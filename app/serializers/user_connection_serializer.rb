class UserConnectionSerializer < ActiveModel::Serializer
  attributes :id, :is_approved, :is_approver?
  has_one :user, serializer: UserMicroSerializer

  # Returns other user, not current_user
  def user
    return object.recipient_user if object.recipient_user != scope
    return object.sender_user if object.sender_user != scope
  end

  def is_approver?
    object.is_approver?(scope)
  end

end