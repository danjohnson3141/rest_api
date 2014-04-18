class AllowedActions::UserActions < AllowedActions

  def view
    if @object == @user
      return true if AppSettings::Value.new(:user_profile, user: @object).on?
    else
      return false unless AppSettings::Value.new(:user_profile, user: @object).on?
      return true if AppSettings::Value.new(:view_profiles, user: @user).on?
    end
  end

  def update
    AppSettings::Value.new(:edit_profile, user: @user).on?
  end

end
