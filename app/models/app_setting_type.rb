class AppSettingType < ActiveRecord::Base
  include User::Associations
  has_one :app_setting_option
end
