class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
    	t.references :user, foreign_key: true
    	t.string :name
    	t.string :image
    	t.string :owner
    	t.string :phone
      t.string :vat_id
      t.string :time_zone
      t.string :address
      t.timestamps

      t.timestamps
    end
  end
end
