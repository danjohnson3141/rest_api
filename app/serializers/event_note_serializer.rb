class EventNoteSerializer < ActiveModel::Serializer
  attributes :id
  has_one :event, serializer: EventShortSerializer
  has_one :event_user
  has_one :event_speaker
  has_one :event_session
  has_one :sponsor
end
