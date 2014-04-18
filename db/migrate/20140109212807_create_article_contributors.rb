class CreateArticleContributors < ActiveRecord::Migration
  def change
    create_table :article_contributors do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :article_contributors, :created_by
    add_index :article_contributors, :updated_by
  end
end
