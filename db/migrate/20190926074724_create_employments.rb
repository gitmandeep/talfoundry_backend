class CreateEmployments < ActiveRecord::Migration[5.2]
  def change
    create_table :employments do |t|
      t.references :profile, foreign_key: true
      t.string :company_name
      t.string :location
      t.string :title
      t.string :role
      t.string :period_month_from
      t.string :period_year_from
      t.string :period_month_to
      t.string :period_year_to
      t.string :employment_description

      t.timestamps
    end
  end
end
