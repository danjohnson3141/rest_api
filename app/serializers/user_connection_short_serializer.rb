class UserConnectionShortSerializer < ActiveModel::Serializer
  attributes :id, :is_approved, :is_approver?

  def is_approver?
    object.is_approver?(scope)
  end

end