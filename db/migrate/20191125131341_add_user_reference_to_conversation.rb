class AddUserReferenceToConversation < ActiveRecord::Migration[5.2]
  def change
  	add_column :conversations, :sender_id, :integer
    add_column :conversations, :recipient_id, :integer
  	add_column :conversations, :uuid, :uuid, default: "gen_random_uuid()", null: false
  end
end
