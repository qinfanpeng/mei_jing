class AddRoleIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :role_id, :Integer, default: 3
  end
end
