class Article < ActiveRecord::Base
  attr_accessible :content, :digest, :image, :publisher, :status, :title, :column_ids

  validates_presence_of :title, :digest, :content, :publisher, :status #, :column_ids
  validates :digest, length: { maximum: 300 }
  validates :status, inclusion: %w[drafted published banned]

  has_and_belongs_to_many :columns
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", large: '450x450>' }

  self.per_page = 12

  searchable do
    text :content, :digest, :publisher, :title
    time :created_at, :updated_at
    text :columns do
      columns.map { |column| column.name }
    end
  end

  scope :banned, -> { where(status: 'banned') }
  scope :drafted, -> { where(status: 'drafted') }
  scope :published, -> { where(status: 'published') }
  default_scope { order('created_at desc') }

end
