class EventUserScheduleSerializer < ActiveModel::Serializer
  attributes :id
  has_one :event_session
  has_one :event_user
end
