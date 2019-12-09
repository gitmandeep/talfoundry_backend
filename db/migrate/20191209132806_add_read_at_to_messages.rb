class AddReadAtToMessages < ActiveRecord::Migration[5.2]
  def change
  	add_column :messages, :read_at, :datetime
  end
end
