class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
    	t.string :job_title
    	t.string :job_category
    	t.text   :job_description
    	t.string :job_document
    	t.string :job_type
    	t.string :job_api_integration
    	t.string :job_expertise_required
    	t.string :job_visibility
    	t.string :number_of_freelancer_required
    	t.string :job_pay_type
    	t.string :job_experience_level
    	t.string :job_duration
    	t.string :job_time_requirement

      t.timestamps
    end
  end
end
