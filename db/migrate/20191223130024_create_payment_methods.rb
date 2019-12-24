class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
	create_table :payment_methods do |t|
		t.references :user, foreign_key: true
		t.string :user_account_id
		t.string :name
		t.string :email
		t.string :account_type
		t.string :payer_id
		t.boolean :verified, :default => false
		t.boolean :email_verified, :default => false
	end
  end
end
