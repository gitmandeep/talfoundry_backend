class RenameLocationInEmployment < ActiveRecord::Migration[5.2]
  def change
  	rename_column :employments, :location, :country
  end
end
