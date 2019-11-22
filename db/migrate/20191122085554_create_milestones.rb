class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
    	t.references :contract, foreign_key: true
      t.uuid :uuid, default: "gen_random_uuid()", null: false
      t.string :description
      t.datetime :due_date
      t.string :deposite_amount

      t.timestamps
    end
  end
end
