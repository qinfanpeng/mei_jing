class Article < ActiveRecord::Base
  attr_accessible :content, :digest, :image, :publisher, :status, :title, :column_ids

  has_and_belongs_to_many :columns
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", mini: '80x80>' }
end
