class AddUuidToExistingTable < ActiveRecord::Migration[5.2]
  def change
  	add_column :profiles, :uuid, :uuid, default: "gen_random_uuid()", null: false
  	add_column :educations, :uuid, :uuid, default: "gen_random_uuid()", null: false
  	add_column :employments, :uuid, :uuid, default: "gen_random_uuid()", null: false
  	add_column :certifications, :uuid, :uuid, default: "gen_random_uuid()", null: false
  	add_column :jobs, :uuid, :uuid, default: "gen_random_uuid()", null: false
  	add_column :job_qualifications, :uuid, :uuid, default: "gen_random_uuid()", null: false
  	add_column :job_screening_questions, :uuid, :uuid, default: "gen_random_uuid()", null: false
  end
end
