class AppSettings::GroupCheck < AppSettings::AppCheck

  def check?
    raise ApiAccessEvanta::PermissionDenied if @option_values.group.nil?
    result = Rails.cache.fetch($tenant.name_space([:app_setting, @type, @value, @option_values.group.id])) do
      AppSetting.where(app_setting_option_id: @value).where(group_id: @option_values.group.id).count > 0
    end

    result
    
  end
end