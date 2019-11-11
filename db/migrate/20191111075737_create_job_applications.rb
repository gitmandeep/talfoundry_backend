class CreateJobApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :job_applications do |t|
    	t.references :user, foreign_key: true
      t.references :job, foreign_key: true
    	t.text   :cover_letter
    	t.string :document
    	t.string :status, :default => "submitted"
    	t.string :price
    	t.uuid	 :uuid, default: "gen_random_uuid()", null: false

      t.timestamps
    end
  end
end
