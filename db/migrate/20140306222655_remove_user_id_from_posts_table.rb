class RemoveUserIdFromPostsTable < ActiveRecord::Migration
  def change
    remove_foreign_key :posts, name: 'posts_user_id_fk'
    remove_column :posts, :user_id, :integer
  end
end
