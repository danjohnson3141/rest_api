class PostFollowerSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user
  has_one :post
end
