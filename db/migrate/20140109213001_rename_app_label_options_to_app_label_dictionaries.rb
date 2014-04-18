class RenameAppLabelOptionsToAppLabelDictionaries < ActiveRecord::Migration
  def self.up
    rename_table :app_label_options, :app_label_dictionaries
  end

  def self.down
    rename_table :app_label_dictionaries, :app_label_options
  end
end
