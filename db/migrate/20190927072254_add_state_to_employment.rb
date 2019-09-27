class AddStateToEmployment < ActiveRecord::Migration[5.2]
  def change
  	add_column :employments, :state, :string
  	add_column :employments, :city, :string
  end
end
