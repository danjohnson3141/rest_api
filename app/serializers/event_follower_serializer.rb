class EventFollowerSerializer < ActiveModel::Serializer
  attributes :id, :created_by, :updated_by
  has_one :user
  has_one :event
end
