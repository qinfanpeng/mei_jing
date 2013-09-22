class Column < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :articles

  def to_param
    "#{id}-#{name}"
  end
end
