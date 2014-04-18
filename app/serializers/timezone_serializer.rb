class TimezoneSerializer < ActiveModel::Serializer
  attributes :id, :name, :offset
end
