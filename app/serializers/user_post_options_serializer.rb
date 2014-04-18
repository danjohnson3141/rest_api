class UserPostOptionsSerializer < ActiveModel::Serializer
  attributes :id
  has_many :groups, serializer: GroupTinySerializer
  has_many :events, serializer: EventTinySerializer

  def groups
    Group.where(id: object.groups.map(&:id)).order(:name)
  end

  def events
    object.user_events
  end

end