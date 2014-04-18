class PostCommentShortSerializer < ActiveModel::Serializer
  attributes :id, :body, :ago
  has_one :user, serializer: UserTinySerializer
end
