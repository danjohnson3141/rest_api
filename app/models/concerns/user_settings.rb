class UserSettings

  attr_accessor :app_setting_options

  def initialize(user)
    @user = user
    @app_setting_options = []
    load_settings
  end

  def load_settings
    AppSettingOption.user.each do |app_setting_option|
      @app_setting_options << app_setting_option if option_enabled?(app_setting_option)
    end
  end

  # Check the dependencies to see if this option is available
  def option_enabled?(app_setting_option)
    AppSettings::DependencyValue.new(app_setting_option, user: @user).on?
  end

end