class PostFollowerPostSerializer < ActiveModel::Serializer
  attributes :id, :post_id
  has_one :user, serializer: UserTinySerializer
end
