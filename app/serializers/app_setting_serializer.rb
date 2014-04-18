class AppSettingSerializer < ActiveModel::Serializer
  attributes :id, :app_setting_option_id, :app_level_setting, :event_id, :group_id, :user_role_id, :user_id, :created_by, :updated_by
end
