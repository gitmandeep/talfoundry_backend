class CreateJobScreeningQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :job_screening_questions do |t|
      t.references :job, foreign_key: true
      t.text :job_question_label
      t.text :job_question

      t.timestamps
    end
  end
end
