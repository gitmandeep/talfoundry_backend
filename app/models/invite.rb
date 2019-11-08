class Invite < ApplicationRecord
	belongs_to :sender, :class_name => 'User'
	belongs_to :recipient, :class_name => 'User'
	belongs_to :job

	# STATUS: ["Accepted", "Open", "Decline"]
	scope :open_invitations, -> { where({ status: "Open"}) }

	def self.get_recipients
		self.pluck(:recipient)
	end
end
