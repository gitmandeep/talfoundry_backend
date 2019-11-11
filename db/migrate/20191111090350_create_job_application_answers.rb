class CreateJobApplicationAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :job_application_answers do |t|
      t.references :job_application, foreign_key: true
    	t.integer   :question_id
    	t.string :answer
    	t.uuid	 :uuid, default: "gen_random_uuid()", null: false

      t.timestamps
    end
  end
end
