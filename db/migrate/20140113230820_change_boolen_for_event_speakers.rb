class ChangeBoolenForEventSpeakers < ActiveRecord::Migration
  def change
    change_column :event_speakers, :moderator, :boolean, :default => 0, :null => false
  end
end
