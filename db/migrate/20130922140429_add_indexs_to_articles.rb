class AddIndexsToArticles < ActiveRecord::Migration
  def self.up
    add_index :articles, [:status, :title, :created_at]
  end

  def self.down
    remove_index :articles, [:status, :title, :created_at]
  end
end
