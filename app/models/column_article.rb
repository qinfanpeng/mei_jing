class ColumnArticle < ActiveRecord::Base
  attr_accessible :column_id, :article_id

  belongs_to :column
  belongs_to :article

  def self.update_column_articles(column_ids, article_id)
    return false unless column_ids
    column_ids.each do |column_id|
      unless self.find_or_create_by_column_id_and_article_id(column_id: column_id, article_id: article_id)
        return false
      end
    end
    true
  end
end
