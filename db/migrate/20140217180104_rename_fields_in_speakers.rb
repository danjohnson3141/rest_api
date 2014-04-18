class RenameFieldsInSpeakers < ActiveRecord::Migration
  def change
    rename_column :event_speakers, :first, :first_name
    rename_column :event_speakers, :last, :last_name
  end
end
