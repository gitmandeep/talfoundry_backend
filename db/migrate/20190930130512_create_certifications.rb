class CreateCertifications < ActiveRecord::Migration[5.2]
  def change
    create_table :certifications do |t|
      t.references :profile, foreign_key: true
      t.string :certification_name
      t.string :certification_link

      t.timestamps
    end
  end
end
