class PostFollowerUserSerializer < ActiveModel::Serializer
  attributes :id, :user_id
  has_one :post, serializer: PostShortSerializer
end
