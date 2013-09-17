class ChangeColumnAticlesToColumnsArticles < ActiveRecord::Migration
  def change
    rename_table :column_articles, :columns_articles
  end
end
