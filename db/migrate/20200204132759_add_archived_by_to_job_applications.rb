class AddArchivedByToJobApplications < ActiveRecord::Migration[5.2]
  def change
  	add_column :job_applications, :archived_by, :integer
  end
end
