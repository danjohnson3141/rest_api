class NavigationLeft

  include ActiveModel::Serialization

  def initialize(current_user)
    @user = current_user
  end

  def show_messages
    AppSettings::Value.new(:messages, user: @user).on?
  end

  def show_notifications
    AppSettings::Value.new(:notifications, user: @user).on?
  end

  def show_search
    AppSettings::Value.new(:search, user: @user).on?
  end

  def show_user_profile
    AppSettings::Value.new(:user_profile, user: @user).on?
  end

  def show_posts_count
    AppSettings::Value.new(__method__, user: @user).on?
  end

  def show_likes_count
    AppSettings::Value.new(__method__, user: @user).on?
  end

  def show_connections_count
    AppSettings::Value.new(__method__, user: @user).on?
  end

  def show_groups
    AppSettings::Value.new(:groups_in_navigation, user: @user).on?
  end

  def show_events
    AppSettings::Value.new(:events, user: @user).on?
  end

  def show_app_sponsors
    AppSettings::Value.new(:app_sponsors).on?
  end

  def show_support_link
    AppSettings::Value.new(:support_link).on?
  end

  def new_message_count
    @user.new_message_count if show_messages
  end

  def new_notification_count
    @user.new_notification_count if show_notifications
  end

  def user_headshot
    @user.photo if show_user_profile
  end

  def user_full_name
    @user.full_name if show_user_profile
  end

  def user_title
    @user.title if show_user_profile
  end

  def user_organization
    @user.organization_name if show_user_profile
  end

  def user_post_count
    @user.posts.count if show_posts_count
  end

  def user_like_count
    @user.post_likes.count if show_likes_count
  end

  def user_connection_count
    @user.approved_user_connections.count if show_connections_count
  end

  def user_pending_connection_count
    @user.users_pending_connection.count if show_connections_count
  end

  def user_groups
    if show_groups
      @user.groups.limit(3)
    else
      []
    end
  end

  def user_events
    if show_events
      @user.my_events.limit(3)
    else
      []
    end
  end

  def user_today_events
    if show_events
      @user.todays_events
    else
      []
    end

  end

end
