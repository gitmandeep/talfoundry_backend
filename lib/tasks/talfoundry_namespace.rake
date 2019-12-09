namespace :talfoundry_namespace do
  desc "TODO"
  task generate_username: :environment do
  	User.where(user_name: nil).each do |user|
  		user.user_name = user.last_name.downcase+'_'+ user.first_name.downcase+'_'+ SecureRandom.hex(5)
  		user.save!
  	end
  end

end
