class AllowedActions::PostActions < AllowedActions

  def view
    return true if @object.creator == @user
    return true if @object.group.present? && @user.viewable_groups.include?(@object.group)
    return true if @object.event.present? && @user.event_user?(@object.event)
    return true if @object.event.present? && @user.viewable_groups.include?(@object.event.group)
    return true if @object.event_session.present? && @user.event_user?(@object.event_session.event)
    return true if @object.event_session.present? && @user.viewable_groups.include?(@object.event_session.event.group)
  end

  def like
    return false if AppSettings::Value.new(:like_posts, user: @user).off?
    return false if @object.group.present? && AppSettings::Value.new(:like_group_posts, group: @object.group).off?
    return false if @object.get_event.present? && AppSettings::Value.new(:like_event_posts, event: @object.get_event).off?
    return true
  end

  def comment
    return false if @object.group.present? && AppSettings::Value.new(:group_post_comments, group: @object.group, user: @user).off?
    return false if @object.get_event.present? && AppSettings::Value.new(:event_post_comments, event: @object.get_event, user: @user).off?
    return true
  end

  def destroy
    super && AppSettings::Value.new(:post_deletes, user: @user).on?
  end


end
