class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts do |t|
      t.references :job, foreign_key: true
      t.string :title
      t.uuid :uuid, default: "gen_random_uuid()", null: false
      t.string :payment_mode
      t.decimal :hourly_rate
      t.string :time_period
      t.string :time_period_limit
      t.datetime :start_date
      t.decimal :weekly_payment
      t.string :description
      t.string :attachment
      t.string :status
      t.string :fixed_price_mode
      t.string :fixed_price_amount
      t.integer :hired_by_id
      t.integer :freelancer_id
      t.string :contract_uniq_id

      t.timestamps
    end
  end
end
