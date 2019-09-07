class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_one :profile

  validates :first_name, :last_name, :role, presence: true
  validates :email, uniqueness: true

  def display_full_name
    "#{first_name} #{last_name}"
  end

end
