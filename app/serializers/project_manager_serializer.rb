class ProjectManagerSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :email, :country, :first_name, :last_name, :full_name, :image_url, :account_active, :project_manager_jobs, :created_at, :number_of_jobs_posted
	#has_one :profile, serializer: ProfileSerializer
	has_one :company, serializer: CompanySerializer

	def full_name
		object.first_name + " " + object.last_name
	end

	def project_manager_jobs
		unless current_user.is_hiring_manager?
			object.jobs.limit(5).offset(1)
		end
	end

	def number_of_jobs_posted
		unless current_user.is_hiring_manager?
			object.jobs.try(:count)
		end
	end

	def image_url
		object.image.try(:url)
	end

	# def image_base64
	# 	if current_user.role != "admin"
	# 		img = open(object.image.try(:url)) rescue ''
	# 		img_base64 = Base64.encode64(img.read) rescue ''
	# 	else
	# 		''
	# 	end
	# end
end
