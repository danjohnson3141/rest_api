class AddUniqueIndexToAppLabelDictionaries < ActiveRecord::Migration
  def change
    change_column :app_label_dictionaries, :name, :string, :limit => nil
    add_column :app_label_dictionaries, :key, :string, index: true, after: :id, :null => false
    add_index :app_label_dictionaries, [:app_label_page_id, :key], :unique => true, :name => 'index_app_label_dictionaries_on_key_and_app_label_page_id'
  end
end
