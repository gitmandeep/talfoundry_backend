class AddAccountActiveToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :account_active, :boolean, :default => true  	
  end
end
