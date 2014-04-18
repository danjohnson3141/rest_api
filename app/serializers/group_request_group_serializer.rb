class GroupRequestGroupSerializer < ActiveModel::Serializer
  attributes :id
  has_one :group, serializer: GroupShortSerializer
end
