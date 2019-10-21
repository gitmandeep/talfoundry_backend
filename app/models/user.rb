class User < ApplicationRecord
  searchkick
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :capitalize_names

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_one :profile, :dependent => :destroy
  has_many :jobs, :dependent => :destroy


  validates :first_name, :last_name, :role, presence: true
  validates :email, uniqueness: true

  scope :admin_freelancer_index, -> { where({ role: "freelancer", profile_created: true }) }
  scope :manager_freelancer_index, -> { where({ role: "freelancer", account_approved: true }) }



  def display_full_name
    "#{first_name} #{last_name}"
  end

  def capitalize_names
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
  end
  
   def search_data
    {
      first_name: first_name,
      last_name: last_name
    }
  end
end
