class AppSettings::AppCheck

  def initialize(type, value, option_values)
    @type = type
    @value = value
    @option_values = option_values
  end

  def check?
    result = Rails.cache.fetch($tenant.name_space([:app_setting, @type, @value])) do
      AppSetting.where(app_setting_option_id: @value).count > 0
    end
    result
  end
end