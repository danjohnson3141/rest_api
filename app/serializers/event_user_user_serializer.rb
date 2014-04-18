class EventUserUserSerializer < ActiveModel::Serializer
  attributes :id
  has_one :event_registration_status
  has_one :user, serializer: UserShortSerializer
  has_one :sponsor, serializer: SponsorShortSerializer
end
