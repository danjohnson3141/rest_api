class AllowedActions

  def initialize(object: object, user: user)
    @object = object
    @user = user
  end

  def update
    @object.respond_to?("user") && (@object.user == @user) || @user.creator?(@object)
  end

  def destroy
    @object.respond_to?("user") && (@object.user == @user) || @user.creator?(@object)
  end

end