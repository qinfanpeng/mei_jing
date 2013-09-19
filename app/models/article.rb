class Article < ActiveRecord::Base
  attr_accessible :content, :digest, :image, :publisher, :status, :title, :column_ids

  validates_presence_of :title, :digest, :content, :publisher, :column_ids, :status
  validates :digest, length: { maximum: 100 }
  validates :status, inclusion: %w[drafted published banned]

  has_and_belongs_to_many :columns
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", large: '450x450>' }

  self.per_page = 10
end
