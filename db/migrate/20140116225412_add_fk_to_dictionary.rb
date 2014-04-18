class AddFkToDictionary < ActiveRecord::Migration
  def up
    change_table :app_label_dictionaries do |t|
      t.foreign_key :app_label_pages
    end
  end
  def down
    remove_foreign_key(:app_label_dictionaries, :app_label_pages)
  end
end
