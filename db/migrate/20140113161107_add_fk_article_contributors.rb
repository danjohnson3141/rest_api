class AddFkArticleContributors < ActiveRecord::Migration
  def up
    change_table :article_contributors do |t|
      t.foreign_key :users
      t.foreign_key :posts
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'
    end
  end
  def down
    remove_foreign_key(:article_contributors, name: 'article_contributors_created_by_fk')
    remove_foreign_key(:article_contributors, name: 'article_contributors_updated_by_fk')
    remove_foreign_key(:article_contributors, :users)
    remove_foreign_key(:article_contributors, :posts)
  end
end
