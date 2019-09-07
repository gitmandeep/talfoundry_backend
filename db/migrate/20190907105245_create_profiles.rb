class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :profile_picture
      t.string :resume
      t.string :current_location_country
      t.string :current_location_city
      t.string :citizenship_country
      t.string :citizenship_full_name
      t.string :skype_user_name
      t.string :english_proficiency
      t.string :skill
      t.string :linkedin_profile
      t.string :github_profile
      t.string :personal_website
      t.string :development_experience
      t.string :look_for_in_company
      t.string :project_type_to_work
      t.string :project_contributed_on
      t.string :current_company_name
      t.string :current_job_title
      t.text	 :about_me
      t.boolean :worked_as_freelancer
      t.text	 :freelancing_pros_cons
      t.date 	 :start_date
      t.string :current_working_hours
      t.string :working_hours_talfoundry
      t.string :engagement_time
      t.text	 :key_success_point
      t.text	 :problem_handling_strategy

      t.timestamps
    end
  end
end
