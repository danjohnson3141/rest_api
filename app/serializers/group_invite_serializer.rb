class GroupInviteSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user
  has_one :group
end
