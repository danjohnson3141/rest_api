class EventSessionMicroSerializer < ActiveModel::Serializer
  attributes :id
  has_one :event, serializer: EventTinySerializer
end
