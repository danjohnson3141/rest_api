class AddFkToDictionaryPart2 < ActiveRecord::Migration
  def up
    change_table :app_label_dictionaries do |t|
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'
    end
  end
end
