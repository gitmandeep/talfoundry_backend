class AddStatusUpdatedAtToContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :status_updated_at, :datetime
  end
end
