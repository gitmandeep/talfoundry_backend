class AddVisibilityToProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :profiles, :visibility, :string, :default => "public"  	
  end
end
