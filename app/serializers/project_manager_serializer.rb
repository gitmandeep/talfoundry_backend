class ProjectManagerSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
	attributes :email
	attributes :full_name
	#attributes :user_picture
	#attributes :profile_created
	#attributes :account_approved
	attributes :account_active
	#attributes :created_at
	attributes :project_manager_jobs


  has_one :profile, serializer: ProfileSerializer
  


  def full_name
  	object.first_name + " " + object.last_name
  end

	def project_manager_jobs
		unless current_user.role == "Project Manager"
			object.jobs.limit(5).offset(1)
		end
	end

  # def user_picture
  #   if object.profile_created
  # 	 object.profile.profile_picture.try(:url)
  #   end
  # end

end
