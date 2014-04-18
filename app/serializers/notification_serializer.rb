class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :body, :is_viewed, :notification_user_id, :post_id, :group_id, :group_invite_id, :ago
  has_one :user, serializer: UserNanoSerializer
  has_one :event, serializer: EventTinySerializer
  has_one :user_connection, serializer: UserConnectionShortSerializer
end
