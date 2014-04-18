class GroupFeaturedPostSerializer < ActiveModel::Serializer
  attributes :id, :group_id
  has_one :post, serializer: PostShortSerializer
  # has_one :group
end
