class AddJobSpecialityToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :job_speciality, :string
  end
end
