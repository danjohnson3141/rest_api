class PostLikePostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :ago
  has_one :post, serializer: PostTinySerializer
end
