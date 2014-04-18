class GroupTinySerializer < ActiveModel::Serializer
  attributes :id, :name, :group_type_name

  def group_type_name
    object.group_type.name
  end
end