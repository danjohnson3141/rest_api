class CreateAppSponsors < ActiveRecord::Migration
  def change
    create_table :app_sponsors do |t|
      t.string :name
      t.string :sponsor_type
      t.text :description
      t.string :logo
      t.string :url
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :app_sponsors, :created_by
    add_index :app_sponsors, :updated_by
  end
end
