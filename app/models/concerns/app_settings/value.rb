OptionValues ||= Struct.new(:user, :event, :group)

class AppSettings::Value

  def initialize(key, user: nil, event: nil, group: nil)
    @key = key
    @option_values = OptionValues.new(user, event, group)
    load_app_setting_options
  end


  def on?
    !value
  end

  def off?
    value
  end


  def value
    @app_setting_options.each do |app_setting_option_id|
      dependencies(app_setting_option_id).each do |type, value|
        return true if type_check?(type, value)
      end
    end

    false
  end

  private

    def type_check?(type, value)
      "AppSettings::#{type}Check".constantize.new(type, value, @option_values).check?
    end

    # Builds the dependency tree and groups all the options in the tree by their type. ex: (user, group, event)
    def dependencies(app_setting_option_id)
      AppSettingOption.cached_find(app_setting_option_id).dependencies_grouped_by_types
    end

    # Gets all the app setting option ids assocaited with the given key
    def load_app_setting_options
      @app_setting_options = AppSettings::Key.find(@key)
      raise ApiAccessEvanta::Unprocessable if @app_setting_options.nil?
    end
end