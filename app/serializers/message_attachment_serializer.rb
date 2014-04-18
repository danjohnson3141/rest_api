class MessageAttachmentSerializer < ActiveModel::Serializer
  attributes :id, :created_by, :updated_by
  has_one :message
end
