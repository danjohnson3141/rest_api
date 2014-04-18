class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, limit: 200
      t.text :description
      t.boolean :group_is_visible, null: false
      t.boolean :group_is_leavable
      t.boolean :show_member_list
      t.references :group_type, index: true
      t.integer :owner_user_id
      t.integer :app_sponsor_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :groups, :owner_user_id
    add_index :groups, :app_sponsor_id
    add_index :groups, :created_by
    add_index :groups, :updated_by
  end
end
