class PostLikeUserSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :ago
  has_one :user, serializer: UserShortSerializer
end
