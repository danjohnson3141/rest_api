class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :alt_email, :first_name, :last_name, :title, :organization_name, :bio, :photo, :can_message, :user_role_id, :user_connections_blocked?, :post_count,
  :post_like_count, :post_comment_count, :user_connection_count, :user_profile?, :can_edit_profile?
  has_one :connection_status, serializer: UserConnectionShortSerializer
  has_many :event_notes, serializer: EventNoteShortSerializer
  has_many :groups, serializer: GroupTinySerializer
  has_many :attended_events, serializer: EventTinySerializer

  def event_notes
    scope.event_notes_for_user(object)
  end

  def groups
    if scope == object
      object.groups.sort_by(&:name)
    else
      return [] unless AppSettings::Value.new(:show_me_on_lists, user: object).on?
      ((object.open_group_memberships + object.private_group_memberships) + (scope.secret_group_memberships & object.secret_group_memberships)).uniq.sort_by(&:name)
    end
  end

  def attended_events
    if scope == object
      return object.attended_events
    else
      return [] unless AppSettings::Value.new(:show_me_on_lists, user: object).on?
      if AppSettings::Value.new(:view_events_not_a_part_of, user: scope).on?
        scoped_events = scope.attended_events
        scoped_groups = scope.groups
        return object.attended_events.select { |event| scoped_groups.map(&:id).include?(event.group_id) || scoped_events.map(&:id).include?(event.id) }
      else
        return object.attended_events & scope.attended_events
      end
    end
  end

  def user_connection_count
    if scope == object
      object.user_connection_count
    else
      return unless AppSettings::Value.new(:user_connections, user: object).on?
      object.user_connection_count
    end
  end

  def can_message
    scope.can_send_message_to?(object)
  end

  def post_like_count
    return unless AppSettings::Value.new(:show_likes_count, user: object).on?
    if scope == object
      object.post_like_count
    else
      object.viewable_posts_likes_sorted_by_activity(scope).uniq.count
    end
  end

  def post_count
    return unless AppSettings::Value.new(:show_posts_count, user: object).on?    
    if scope == object
      object.post_count
    else
      object.viewable_posts_sorted_by_activity(scope).uniq.count
    end
  end

  def connection_status
    return if user_connections_blocked?
    scope.connected_to_user(object)
  end

  def user_connections_blocked?
    AppSettings::Value.new(:user_connections, user: object).off?
  end

  def can_edit_profile?
    return false if scope != object
    AppSettings::Value.new(:edit_profile, user: object).on?
  end
end
