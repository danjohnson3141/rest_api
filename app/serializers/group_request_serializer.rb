class GroupRequestSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user, serializer: UserShortSerializer
  has_one :group, serializer: GroupShortSerializer
end
