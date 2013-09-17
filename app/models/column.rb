class Column < ActiveRecord::Base
  attr_accessible :name

  has_many :column_articles
  has_many :articles, through: :column_articles
end
