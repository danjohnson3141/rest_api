class GroupMemberGroupSerializer < ActiveModel::Serializer
  attributes :id, :user_id
  has_one :group, serializer: GroupShortSerializer
end