class UserMicroSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :user_connections_blocked?, :user_profile?
  has_one :connection_status, serializer: UserConnectionShortSerializer

  def connection_status
    return if user_connections_blocked?
    scope.connected_to_user(object)
  end

  def user_connections_blocked?
    AppSettings::Value.new(:user_connections, user: object).off?
  end

end