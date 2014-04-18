class SponsorTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :display_rank
end
