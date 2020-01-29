class AddPhoneVerificationCodeToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :phone_verification_code, :string
  	add_column :users, :phone_verified, :boolean, :default => false
  end
end
