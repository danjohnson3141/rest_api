class PostAttachmentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :url, :created_by, :ago
end
