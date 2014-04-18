class NavigationLeftSerializer < ActiveModel::Serializer
  attributes :show_messages, :show_notifications, :show_search, :show_user_profile, :show_posts_count, :show_likes_count, :show_connections_count, :show_groups, :show_events, :show_app_sponsors,
  :show_support_link, :new_message_count, :new_notification_count, :user_headshot, :user_full_name, :user_title, :user_organization, :user_post_count, :user_like_count, :user_connection_count,
  :user_pending_connection_count, :user_events, :user_today_events
  has_many :user_groups, serializer: GroupTinySerializer
  has_many :user_events, serializer: EventTinySerializer
  has_many :user_today_events, serializer: EventTinySerializer
end
