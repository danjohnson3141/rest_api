class EventFollowerUserSerializer < ActiveModel::Serializer
  attributes :id, :user_id
  has_one :event
end
