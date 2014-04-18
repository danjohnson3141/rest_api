class AllowedActions::GroupActions < AllowedActions

  def view
    @user.group_member?(@object) || @object.group_type.is_content_visible?
  end

  def view_secret
    !@object.secret? || (@user.group_member?(@object) && @object.secret?)
  end

end