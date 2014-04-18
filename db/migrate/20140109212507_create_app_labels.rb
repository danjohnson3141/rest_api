class CreateAppLabels < ActiveRecord::Migration
  def change
    create_table :app_labels do |t|
      t.string :singular
      t.string :plural
      t.references :app_label_option, index: true
      t.references :app_label_language, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :app_labels, :created_by
    add_index :app_labels, :updated_by
  end
end
