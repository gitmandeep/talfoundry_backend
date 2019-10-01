class AddProfessionalProfileCreatedToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :professional_profile_created, :boolean, :default => false
  end
end
