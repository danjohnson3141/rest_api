class GroupInviteUserSerializer < ActiveModel::Serializer
  attributes :id, :group_id
  has_one :user, serializer: UserShortSerializer
end
