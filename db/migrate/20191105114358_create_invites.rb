class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.integer :job_id
      t.integer :recipient_id
      t.integer :sender_id
      t.string :message
      t.string :status
      t.datetime :status_updated_at
      

      t.timestamps
    end
  end
end
