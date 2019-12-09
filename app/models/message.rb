class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  scope :unread, -> {where(read_at: nil)}
end
