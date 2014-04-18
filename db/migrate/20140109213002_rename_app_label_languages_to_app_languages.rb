class RenameAppLabelLanguagesToAppLanguages < ActiveRecord::Migration
  def self.up
    rename_table :app_label_languages, :app_languages
  end

  def self.down
    rename_table :app_languages, :app_label_languages
  end
end
