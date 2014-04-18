class AllowedActions::GroupRequestActions < AllowedActions

  def destroy
    @object.user == @user || @object.group.owner == @user
  end

end