require_relative '20200114092926_create_payments_and_payouts'

class FixUpLastMigrationAndCreatePayments < ActiveRecord::Migration[5.2]
  def change
  	revert CreatePaymentsAndPayouts

  	create_table :transaction_histories do |th|
  		th.references :manager
      th.references :freelancer
    	th.string :payment_mode
    	th.references :contract, foreign_key: true
    	th.references :milestone, foreign_key: true
      th.string :transaction_type
      th.string :description
      th.string :payment_type
    	th.string :order_id
    	th.string :payer_id
    	th.integer :amount
      th.integer :balance
    	th.string :payee_id
    	th.string :status
    	th.string :capture_id
    	th.string :refund_id
    	th.timestamps
    end

    create_table :requested_payments do |rp|
    	rp.references :user, foreign_key: true
    	rp.string :payee_id
    	rp.string :status
    	rp.integer :amount_requested
    	rp.integer :amount_paid
    	rp.string :payer_account
    	rp.references :contract, foreign_key: true
    	rp.references :milestone, foreign_key: true
    	rp.string :request_message
    	rp.string :response_message
    	rp.timestamps
    end

    add_column :payment_methods, :created_at, :datetime, null: false
    add_column :payment_methods, :updated_at, :datetime, null: false
    add_column :notifications, :activity, :string
  end
end
