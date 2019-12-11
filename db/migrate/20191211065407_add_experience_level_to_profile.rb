class AddExperienceLevelToProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :profiles, :experience_level, :string
  	add_column :profiles, :search_engine_privacy, :string
  	add_column :profiles, :project_preference, :string
  	add_column :profiles, :earnings_privacy, :string
  end
end
