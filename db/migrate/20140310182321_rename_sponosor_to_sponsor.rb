class RenameSponosorToSponsor < ActiveRecord::Migration
  def change
    rename_column :sponsors, :splash_sponosor, :splash_sponsor
  end
end
