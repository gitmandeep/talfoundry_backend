class AddAdditionalExpertiseToJob < ActiveRecord::Migration[5.2]
  def change
  	add_column :jobs, :job_additional_expertise_required, :string
  end
end

