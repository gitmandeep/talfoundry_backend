class CreateSearchHistory < ActiveRecord::Migration[5.2]
  def change
    create_table :search_histories do |t|
    	t.references :user, foreign_key: true
    	t.string :keyword
    	t.uuid	 :uuid, default: "gen_random_uuid()", null: false
      t.timestamps
    end
  end
end
