class CreateAppLabelTranslations < ActiveRecord::Migration
  def self.up
    AppLabel.create_translation_table!({
      :label => :string
    }, {
      :migrate_data => true
    })
  end

  def self.down
   AppLabel.drop_translation_table! :migrate_data => true
  end
end
