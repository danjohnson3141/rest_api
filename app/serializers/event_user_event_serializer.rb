class EventUserEventSerializer < ActiveModel::Serializer
  attributes :id
  has_one :event_registration_status
  has_one :event, serializer: EventShortSerializer
  has_one :sponsor, serializer: SponsorShortSerializer
  
end
