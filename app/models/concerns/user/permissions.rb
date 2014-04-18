module User::Permissions

  extend ActiveSupport::Concern

  # All methods here should return a boolen for the given permission - no exceptions should be raised here.
  included do 

    # core allowed_to method - forks logic to individual obect's allowed action classes
    def allowed_to?(action: action, object: object)
      return false if object.nil?
      allowed_actions = "AllowedActions::#{object.class.name}Actions".constantize.new(object: object, user: self)
      return false unless allowed_actions.respond_to? action
      allowed_actions.send(action)
    end

    def can_join_groups?
      AppSettings::Value.new(:join_groups, user: self).on?
    end

    def user_profile?
      AppSettings::Value.new(:user_profile, user: self).on?
    end

    def account_active?
      AppSettings::Value.new(:account_active, user: self).on?
    end

    def can_view_likes?(user)
      AppSettings::Value.new(:show_likes_count, user: user).on? && AppSettings::Value.new(:view_profiles, user: self).on?
    end

    def can_view_post_likes_list?
      AppSettings::Value.new(:show_post_likes_list, user: self).on?
    end

    def create_articles?
      AppSettings::Value.new(:articles, user: self).on?
    end

    def create_posts?
      AppSettings::Value.new(:create_user_posts, user: self).on?
    end

    def delete_posts?
      AppSettings::Value.new(:post_deletes, user: self).on?
    end

    def view_profiles?
      AppSettings::Value.new(:view_profiles, user: self).on?
    end

    def events_section?
      AppSettings::Value.new(:events, user: self).on?
    end

    def event_evaluations?
      AppSettings::Value.new(:user_event_evaluations, user: self).on?
    end

    def event_session_evaluations?
      AppSettings::Value.new(:user_event_session_evaluations, user: self).on?
    end

    def show_likes_count?
      AppSettings::Value.new(:show_likes_count, user: self).on?
    end

    def like_posts?
      AppSettings::Value.new(:like_posts, user: self).on?
    end

    def post_comment_updates?
      AppSettings::Value.new(:post_comment_updates, user: self).on?
    end

    def post_comments?
      AppSettings::Value.new(:post_comments, user: self).on?
    end

    def show_posts_count?
      AppSettings::Value.new(:show_posts_count, user: self).on?
    end

    def show_connections_count?
      AppSettings::Value.new(:show_connections_count, user: self).on?
    end

    def connections_enabled?
      AppSettings::Value.new(:connections, user: self).on?
    end

    def user_connections_enabled?
      AppSettings::Value.new(:user_connections, user: self).on?
    end

    def view_my_connections_enabled?
      AppSettings::Value.new(:block_viewing_my_connections, user: self).on?
    end

    def notifications?
      AppSettings::Value.new(:notifications, user: self).on?
    end

    def view_event?(event)
      (self.viewable_groups.map(&:id).include?(event.group_id) || self.user_events.map(&:id).include?(event.id)) && self.events_section?
    end

    def attachments?(post)
      event = post.get_event
      group = post.group

      return AppSettings::Value.new(:event_post_attachments, event: event, user: self).on? if event.present?
      return AppSettings::Value.new(:group_post_attachments, group: group, user: self).on? if group.present?
      false
    end

    def can_send_messages?
      AppSettings::Value.new(:send_messages, user: self).on?
    end

    def can_receive_messages?(user)
      return false unless AppSettings::Value.new(:receive_messages_from_connections, user: self).on?

      if AppSettings::Value.new(:receive_messages, user: self).on?
        return true
      else
        # Check whether or no they are connected
        return connected_to_user(user).present?
      end
      false
    end
    
    def can_send_message_to?(user)
      can_send_messages? && user.can_receive_messages?(self)
    end

    def creator?(object)
      self.id == object.created_by
    end

  end

end