class CreateEducations < ActiveRecord::Migration[5.2]
  def change
    create_table :educations do |t|
      t.references :profile, foreign_key: true
    	t.string :school
      t.date :from_date
      t.date :to_date
      t.string :degree
      t.string :area_of_study
      t.string :education_description
      t.timestamps
    end
  end
end
