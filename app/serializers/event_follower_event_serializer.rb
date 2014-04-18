class EventFollowerEventSerializer < ActiveModel::Serializer
  attributes :id, :event_id
  has_one :user
end
