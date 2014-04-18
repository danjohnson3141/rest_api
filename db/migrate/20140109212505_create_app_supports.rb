class CreateAppSupports < ActiveRecord::Migration
  def change
    create_table :app_supports do |t|
      t.text :body
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :app_supports, :created_by
    add_index :app_supports, :updated_by
  end
end
