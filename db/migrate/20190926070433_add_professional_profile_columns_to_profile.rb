class AddProfessionalProfileColumnsToProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :profiles, :professional_title, :string
  	add_column :profiles, :professional_overview, :text
  	add_column :profiles, :youtube_video_link, :string, :null => true
  	add_column :profiles, :youtube_video_type, :string, :null => true
  	add_column :profiles, :hourly_rate, :string
  	add_column :profiles, :availability, :string
  end
end
