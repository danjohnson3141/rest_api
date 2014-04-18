class RenameFieldsInSpeakersAgain < ActiveRecord::Migration
  def change
    rename_column :event_speakers, :organization, :organization_name
  end
end
