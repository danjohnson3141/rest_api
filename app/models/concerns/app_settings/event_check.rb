class AppSettings::EventCheck < AppSettings::AppCheck

  def check?
    raise ApiAccessEvanta::PermissionDenied if @option_values.event.nil?
    result = Rails.cache.fetch($tenant.name_space([:app_setting, @type, @value, @option_values.event.id])) do
      AppSetting.where(app_setting_option_id: @value).where(event_id: @option_values.event.id).count > 0
    end

    result
    
  end
end

