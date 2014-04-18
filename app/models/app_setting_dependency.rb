class AppSettingDependency < ActiveRecord::Base
  include User::Associations
  belongs_to :app_setting_option
  belongs_to :dependent_app_setting_option, class_name: 'AppSettingOption', foreign_key: :dependent_app_setting_option_id
end