class CreateAppEmails < ActiveRecord::Migration
  def change
    create_table :app_emails do |t|
      t.string :email_from
      t.string :email_subject
      t.text :email_body
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :app_emails, :created_by
    add_index :app_emails, :updated_by
  end
end
