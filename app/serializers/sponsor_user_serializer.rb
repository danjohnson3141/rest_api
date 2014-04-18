class SponsorUserSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user, serializer: UserShortSerializer
end
