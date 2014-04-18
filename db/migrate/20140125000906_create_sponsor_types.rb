class CreateSponsorTypes < ActiveRecord::Migration
  def change
    create_table :sponsor_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
