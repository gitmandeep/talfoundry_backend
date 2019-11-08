class AddUuidToNotificationAndInvite < ActiveRecord::Migration[5.2]
  def change
  	add_column :invites, :uuid, :uuid, default: "gen_random_uuid()", null: false
  	add_column :notifications, :uuid, :uuid, default: "gen_random_uuid()", null: false
  end
end
