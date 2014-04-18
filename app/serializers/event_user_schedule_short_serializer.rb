class EventUserScheduleShortSerializer < ActiveModel::Serializer
  attributes :id
  has_one :event_session, serializer: EventSessionShortSerializer
  has_one :event_user, serializer: EventUserTinySerializer
end
