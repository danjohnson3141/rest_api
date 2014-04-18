class AppSettings::DependencyValue < AppSettings::Value

  def initialize(app_setting_option, user: nil, event: nil, group: nil)
    @app_setting_option = app_setting_option
    @option_values = OptionValues.new(user, event, group)
  end

  def value
    dependencies(@app_setting_option.id).delete("User")
    dependencies(@app_setting_option.id).each do |type, value|
      return true if type_check?(type, value)
    end
    false
  end

end