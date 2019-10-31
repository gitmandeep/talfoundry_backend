class AddColumnToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :category, :string
    add_column :profiles, :certification, :string
  end
end
