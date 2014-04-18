class PostCommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :ago, :post_id
  has_one :user, serializer: UserTinySerializer
end
