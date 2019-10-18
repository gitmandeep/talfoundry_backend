class AddJobPayValueToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :job_pay_value, :string
  end
end
