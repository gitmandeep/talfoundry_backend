class ProjectManagerSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :email, :country, :first_name, :last_name, :full_name, :user_name, :image_url, :account_active, :project_manager_jobs, :created_at, :number_of_jobs_posted, :payment_method
	#has_one :profile, serializer: ProfileSerializer
	has_one :company, serializer: CompanySerializer
	has_many :payment_methods, serializer: PaymentMethodSerializer

	def full_name
		object.first_name + " " + object.last_name
	end

	def project_manager_jobs
		if current_user
			unless current_user.is_hiring_manager? || current_user.is_admin?
				object.jobs.limit(5).offset(1)
			end
		end
	end

	def number_of_jobs_posted
		if current_user
			unless current_user.is_hiring_manager?
				object.jobs.try(:count)
			end
		end
	end

	def image_url
		object.image.try(:url)
	end

	def payment_method
    object.try(:payment_methods).where(account_type: 'paypal')
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
