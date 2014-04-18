class AppSettingOptionSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :app_setting_type
  has_many :app_setting_dependencies

  def app_setting_type
    object.app_setting_type.name
  end

end
