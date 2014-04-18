class EventNoteTinySerializer < ActiveModel::Serializer
  attributes :id, :body
  has_one :event_speaker, serializer: EventSpeakerShortSerializer
  has_one :event_session, serializer: EventSessionShortSerializer
  has_one :sponsor, serializer: SponsorShortSerializer
end
