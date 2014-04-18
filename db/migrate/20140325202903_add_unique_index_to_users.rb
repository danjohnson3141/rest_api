class AddUniqueIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :alt_email, unique: true
  end
end