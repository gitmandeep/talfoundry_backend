class AddProfileTypeToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :profile_type, :string
  end
end
