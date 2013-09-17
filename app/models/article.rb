class Article < ActiveRecord::Base
  attr_accessible :content, :digest, :image, :publisher, :status, :title

  has_many :column_articles
  has_many :columns, through: :column_articles

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
