class PostLikeSerializer < ActiveModel::Serializer
  attributes :id, :ago
  has_one :user, serializer: UserShortSerializer
  has_one :post, serializer: PostTinySerializer
end
