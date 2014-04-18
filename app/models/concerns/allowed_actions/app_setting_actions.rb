class AllowedActions::AppSettingActions < AllowedActions

  def create
    @object.app_setting_option_valid_for_user?(@user)    
  end

end