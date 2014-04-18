class AppSettingDependencySerializer < ActiveModel::Serializer
  # attributes :id, :app_setting_option_id, :dependent_app_setting_option_id
  # attributes :app_setting_option_id
  # attributes :dependent_app_setting_option_id

  has_one :dependent_app_setting_option
  # has_many :app_settings
  # has_many :dependant_app_setting_dependencies

  
end
