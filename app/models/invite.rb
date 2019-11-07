class Invite < ApplicationRecord
	belongs_to :sender, :class_name => 'User'
	belongs_to :recipient, :class_name => 'User'
	belongs_to :job

	# STATUS: ["Accepted", "Open", "Decline"]

	def self.get_recipients
		self.pluck(:recipient)
	end

  scope :open_invite, -> { where({ status: "Open"}) }

end
