class RenameArticleContributorsTable < ActiveRecord::Migration
  def change
    execute "RENAME TABLE `article_contributors` TO `post_contributors`;"
  end
end
