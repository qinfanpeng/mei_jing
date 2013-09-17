class Article < ActiveRecord::Base
  attr_accessible :content, :digest, :image, :publisher, :status, :title

  has_many :column_articles
  has_many :column, through: :column_articles
end
