class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body, :null => false
      t.integer :sender_user_id, :null => false
      t.integer :recipient_user_id, :null => false
      t.datetime :viewed_date
      t.integer :created_by
      t.integer :updated_by

      t.foreign_key :users, column: 'sender_user_id'
      t.foreign_key :users, column: 'recipient_user_id'
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'

      t.timestamps
    end
    add_index :messages, :sender_user_id
    add_index :messages, :recipient_user_id
    add_index :messages, :created_by
    add_index :messages, :updated_by
  end
end
