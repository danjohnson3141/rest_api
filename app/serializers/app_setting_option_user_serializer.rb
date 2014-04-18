class AppSettingOptionUserSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :setting, :app_setting_id

  def setting
    return true if AppSetting.where(app_setting_option: object, user: scope).present?
    false
  end

  def app_setting_id
    AppSetting.where(app_setting_option: object, user: scope).first.try(:id)
  end

end
