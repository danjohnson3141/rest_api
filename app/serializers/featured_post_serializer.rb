class FeaturedPostSerializer < ActiveModel::Serializer
  attributes :id
  has_one :post, serializer: PostSerializer
end
