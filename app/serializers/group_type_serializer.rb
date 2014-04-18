class GroupTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :is_group_visible, :is_memberlist_visible, :is_content_visible, :is_approval_required
end
