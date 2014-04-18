class BannerAdSerializer < ActiveModel::Serializer
  attributes :id, :graphic_link, :sponsor_id, :link_url
  # has_one :group, serializer: GroupShortSerializer
  # has_one :event, serializer: EventShortSerializer
  has_one :sponsor
end
