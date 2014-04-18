class AddFkConnections < ActiveRecord::Migration
  def up
    change_table :connections do |t|
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'sender_user_id'
      t.foreign_key :users, column: 'recipient_user_id'
    end
  end
  def down
    remove_foreign_key(:connections, name: 'connections_created_by_fk')
    remove_foreign_key(:connections, name: 'connections_updated_by_fk')
    remove_foreign_key(:connections, name: 'connections_sender_user_id_fk')
    remove_foreign_key(:connections, name: 'connections_recipient_user_id_fk')
  end
end
