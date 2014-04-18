class GroupShortSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :owner_user_id
  has_one :group_type, serializer: GroupTypeShortSerializer
  has_one :owner, serializer: UserShortSerializer
end
