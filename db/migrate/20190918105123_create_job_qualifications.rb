class CreateJobQualifications < ActiveRecord::Migration[5.2]
  def change
    create_table :job_qualifications do |t|
      t.references :job, foreign_key: true
    	t.string :freelancer_type
    	t.string :job_success_score
    	t.string :billed_on_talfoundry
    	t.string :english_level
    	t.string :rising_talent
    	t.string :qualification_group
    	t.string :location


      t.timestamps
    end
  end
end
