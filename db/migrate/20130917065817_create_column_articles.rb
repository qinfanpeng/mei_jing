
class CreateColumnArticles < ActiveRecord::Migration
  def change
    create_table :column_articles do |t|
      t.integer :column_id
      t.integer :article_id
    end
  end
end
