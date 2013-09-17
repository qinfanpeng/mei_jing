class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.text :digest
      t.string :image
      t.string :publisher
      t.string :status
      t.integer :column_article_id

      t.timestamps
    end
  end
end
