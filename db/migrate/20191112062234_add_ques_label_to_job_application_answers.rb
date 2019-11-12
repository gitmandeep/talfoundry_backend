class AddQuesLabelToJobApplicationAnswers < ActiveRecord::Migration[5.2]
  def change
  	add_column :job_application_answers, :question_label, :string
  end
end
