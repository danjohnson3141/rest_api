class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.text :body
      t.boolean :is_recipient_approved
      t.integer :sender_user_id, :null => false
      t.integer :recipient_user_id, :null => false
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :connections, :sender_user_id
    add_index :connections, :recipient_user_id
    add_index :connections, [:sender_user_id, :recipient_user_id], :unique => true, :name => 'index_connections_on_sender_user_id_and_recipient_user_id'
    add_index :connections, :created_by
    add_index :connections, :updated_by
  end
end
