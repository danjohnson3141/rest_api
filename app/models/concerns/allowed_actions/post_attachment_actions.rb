class AllowedActions::PostAttachmentActions < AllowedActions

  def create
    @object.post.creator == @user && @user.attachments?(@object.post)
  end

end