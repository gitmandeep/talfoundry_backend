class AddJobStatusToJob < ActiveRecord::Migration[5.2]
  def change
  	add_column :jobs, :job_status, :string, :default => "new"  	
  end
end
