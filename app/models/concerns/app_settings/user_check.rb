class AppSettings::UserCheck < AppSettings::AppCheck

  def check?
    raise ApiAccessEvanta::PermissionDenied if @option_values.user.nil?
    
    AppSetting.where(app_setting_option_id: @value).where(user_id: @option_values.user.id).count > 0
  end
end