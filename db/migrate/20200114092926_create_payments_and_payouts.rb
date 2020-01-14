class CreatePaymentsAndPayouts < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
    	t.string :payment_mode
    	t.references :contract, foreign_key: true
    	t.string :order_id
    	t.string :payer_id
    	t.decimal :amount
    	t.string :payee_id
    	t.string :intent
    	t.string :status
    	t.string :capture_id
    end
  end
end
