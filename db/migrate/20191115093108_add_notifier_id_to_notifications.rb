class AddNotifierIdToNotifications < ActiveRecord::Migration[5.2]
  def change
  	add_column :notifications, :notifier_uuid, :uuid
  	add_column :users, :country_id, :integer
  end
end
