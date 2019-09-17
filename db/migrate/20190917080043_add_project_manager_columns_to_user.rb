class AddProjectManagerColumnsToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :company_name, :string
  	add_column :users, :phone_number, :string
  end
end
