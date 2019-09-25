class AddUserToJobs < ActiveRecord::Migration[5.2]
  def change
    add_reference :jobs, :user, foreign_key: true
  end
end
