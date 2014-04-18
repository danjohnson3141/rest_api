class AppLabelDictionarySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :app_label_page_id
  has_one :app_label_page
end
