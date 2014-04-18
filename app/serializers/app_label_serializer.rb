class AppLabelSerializer < ActiveModel::Serializer

  def key
    object.app_label_dictionary.key
  end

  attributes :id, :key, :label, :label_plural
  # has_one :app_label_dictionary
  # has_one :app_language
end
