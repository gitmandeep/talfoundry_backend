class CreateSecurityQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :security_questions do |t|
      t.uuid :uuid, default: "gen_random_uuid()", null: false
      t.references :user, foreign_key: true, index: true
    	t.string :question
    	t.string :answer
      
      t.timestamps
    end
  end
end
