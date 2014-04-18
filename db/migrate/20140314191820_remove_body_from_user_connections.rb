class RemoveBodyFromUserConnections < ActiveRecord::Migration
  def change
    remove_column :user_connections, :body, :text
  end
end
