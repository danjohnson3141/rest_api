class EventUserSerializer < ActiveModel::Serializer
  attributes :id, :sponsor_id
  has_one :event_registration_status
  has_one :user, serializer: UserNanoSerializer
  has_one :event, serializer: EventTinySerializer
  has_one :sponsor, serializer: SponsorShortSerializer
  has_many :event_notes, serializer: EventNoteTinySerializer

end
