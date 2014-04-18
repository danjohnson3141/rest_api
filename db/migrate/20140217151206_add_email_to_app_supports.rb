class AddEmailToAppSupports < ActiveRecord::Migration
  def change
    add_column :app_supports, :email, :string, after: "body", index: true
  end
end
