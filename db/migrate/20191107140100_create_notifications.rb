class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
    	t.integer :sender_id
      t.integer :recipient_id      
      t.string :message
      t.string :message_type
      t.datetime :read_at
      t.timestamps
    end
  end
end
