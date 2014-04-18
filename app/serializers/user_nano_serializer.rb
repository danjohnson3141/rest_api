class UserNanoSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :title, :organization_name, :photo
end