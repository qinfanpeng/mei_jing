class ColumnArticle < ActiveRecord::Base
  attr_accessible :column_id, :article_id

  belongs_to :column
  belongs_to :article

  def self.create_column_articles(column_ids, article_id)
    column_ids.each do |column_id|
      unless self.create(column_id: column_id, article_id: article_id)
        return false
      end
    end
    true
  end
end
