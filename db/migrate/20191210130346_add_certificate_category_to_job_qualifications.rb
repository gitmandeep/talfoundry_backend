class AddCertificateCategoryToJobQualifications < ActiveRecord::Migration[5.2]
  def change
  	add_column :job_qualifications, :certificate_category, :string
  end
end
