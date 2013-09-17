class ChangeColumnsAticlesToArticlesColumns < ActiveRecord::Migration
  def change
    rename_table :columns_articles, :articles_columns
  end
end
