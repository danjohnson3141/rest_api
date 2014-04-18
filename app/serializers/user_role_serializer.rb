class UserRoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_by, :updated_by
end
