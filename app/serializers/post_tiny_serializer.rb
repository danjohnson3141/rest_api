class PostTinySerializer < ActiveModel::Serializer
  attributes :id, :title, :excerpt, :generated_excerpt
  has_one :group, serializer: GroupTinySerializer
  has_one :event, serializer: EventTinySerializer
end