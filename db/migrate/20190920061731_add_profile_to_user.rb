class AddProfileToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :profile_created, :boolean, :default => false
  	add_column :users, :account_approved, :boolean, :default => false
  end
end
