class AddCallScheduleToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :call_schedule, :boolean, :default => false  	
  end
end
