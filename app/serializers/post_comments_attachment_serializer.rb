class PostCommentsAttachmentSerializer < ActiveModel::Serializer
  attributes :id, :created_by, :updated_by
  has_one :post_comment
end
