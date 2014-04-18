class AllowedActions::PostCommentActions < AllowedActions

  def create
    return false unless @user.post_comments?
    return true if @object.post.group.present? && @user.group_member?(@object.post.group)
    return true if @object.post.get_event.present? && @user.event_user?(@object.post.get_event)
    return true if @object.post.get_event.present? && @user.group_member?(@object.post.get_event.group)
  end

  def update
    destroy
  end

  def destroy
    super && @user.post_comment_updates?
  end

end