class ProjectManagerSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :email, :country, :full_name, :account_active, :project_manager_jobs, :created_at, :number_of_jobs_posted
	#attributes :user_picture
	#attributes :profile_created
	#attributes :account_approved
	#attributes :created_at
	has_one :profile, serializer: ProfileSerializer

	def full_name
		object.first_name + " " + object.last_name
	end

	def project_manager_jobs
		unless current_user.role == "Project Manager"
			object.jobs.limit(5).offset(1)
		end
	end

	def number_of_jobs_posted
		unless current_user.role == "Project Manager"
			object.jobs.count
		end
	end

	# def user_picture
	# 	if object.profile_created
	# 		object.profile.profile_picture.try(:url)
	# 	end
	# end
end
