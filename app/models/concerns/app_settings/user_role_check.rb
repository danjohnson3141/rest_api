class AppSettings::UserRoleCheck < AppSettings::AppCheck

  def check?
    raise ApiAccessEvanta::PermissionDenied if @option_values.user.nil?

    result = Rails.cache.fetch($tenant.name_space([:app_setting, @type, @value, @option_values.user.user_role_id])) do
      AppSetting.where(app_setting_option_id: @value).where(user_role_id: @option_values.user.user_role_id).count > 0
    end

    result
    
  end
end