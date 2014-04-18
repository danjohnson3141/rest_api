class CreateEventSpeakers < ActiveRecord::Migration
  def change
    create_table :event_speakers do |t|
      t.string :first, limit: 100
      t.string :last, limit: 100
      t.string :title
      t.string :organization
      t.text :bio
      t.string :speaker_type, limit: 50
      t.boolean :moderator
      t.references :user, index: true
      t.references :event_session, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_speakers, :created_by
    add_index :event_speakers, :updated_by
  end
end
