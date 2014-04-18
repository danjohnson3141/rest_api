class EventNoteShortSerializer < ActiveModel::Serializer
  attributes :id, :body
  has_one :event, serializer: EventTinySerializer
  has_one :event_user, serializer: EventUserTinySerializer
  has_one :event_speaker, serializer: EventSpeakerShortSerializer
  has_one :event_session, serializer: EventSessionShortSerializer
  has_one :sponsor, serializer: SponsorShortSerializer
end
