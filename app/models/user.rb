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
  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id', :dependent => :destroy


  validates :first_name, :last_name, :role, presence: true
  validates :email, uniqueness: true

  scope :admin_freelancer_index, -> { where({ role: "freelancer", profile_created: true }).order(created_at: :desc) }
  scope :manager_freelancer_index, -> { where({ role: "freelancer", account_approved: true }).order(:created_at) }


  # # user types constants
  # TYPE_ADMIN = 1
  # TYPE_FREELANCER = 2
  # TYPE_HIRING_MANAGER = 3
  # # user types names
  # USER_TYPES = {
  #     TYPE_ADMIN => 'admin',
  #     TYPE_FREELANCER => 'freelancer',
  #     TYPE_HIRING_MANAGER => 'Project Manager'
  # }.freeze


  def display_full_name
    "#{first_name} #{last_name}"
  end

  def capitalize_names
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
  end

  def is_hiring_manager?
    self.role == "Project Manager"
  end

  def is_admin?
    self.role == "admin"
  end

  def is_freelancer?
    self.role == "freelancer"
  end
  
  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      full_name: self.display_full_name,
      user_skill: self.profile.try(:skill),
      user_professional_title: self.profile.try(:professional_title)
    }
  end
end
