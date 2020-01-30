class User < ApplicationRecord
  searchkick
  mount_base64_uploader :image, UserImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :current_password

  before_create :capitalize_names, :create_username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_one :profile, :dependent => :destroy
  has_many :jobs, :dependent => :destroy
  has_many :invites, :class_name => "Invite", :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id', :dependent => :destroy
  has_many :notifications, :class_name => "Notification", :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :sent_notifications, :class_name => "Notification", :foreign_key => 'sender_id', :dependent => :destroy
  has_many :job_applications, :dependent => :destroy
  has_many :search_histories, :dependent => :destroy
  has_many :received_contracts, :class_name => "Contract", :foreign_key => 'freelancer_id', :dependent => :destroy
  has_many :contracts, :class_name => "Contract", :foreign_key => 'hired_by_id', :dependent => :destroy
  has_many :messages
  has_many :conversations, foreign_key: :sender_id
  has_one  :company, :dependent => :destroy
  accepts_nested_attributes_for :company

  validates :first_name, :last_name, :role, presence: true
  validates :email, uniqueness: true
  validates :user_name, uniqueness: true

  scope :admin_freelancer_index, -> { where({ role: "freelancer", profile_created: true }).order(created_at: :desc) }
  scope :manager_freelancer_index, -> { where({ role: "freelancer", account_approved: true }).order(:created_at) }
  scope :newest, lambda {where("created_at > ?", 1.month.ago)}
  scope :public_data, -> {where(account_approved: true)}
  
  scope :search_by_status, -> (status) {
      if status == "true"  
        where(account_approved: true, role: "freelancer", profile_created: true).order(created_at: :desc)
      elsif status == "false"
        where(account_approved: false, role: "freelancer", profile_created: true).order(created_at: :desc)
      elsif status == "banned"
        where(account_active: false, role: "freelancer", profile_created: true).order(created_at: :desc)
      else
        where(role: "freelancer", profile_created: true).order(created_at: :desc)
      end
    }

  has_many :favorites
  has_many :favorites_freelancers, through: :favorites, source: :favorited, source_type: 'User'
  has_many :favorite_jobs, through: :favorites, source: :favorited, source_type: 'Job'
  has_many :payment_methods, :dependent => :destroy
  has_many :requested_payments, dependent: :destroy
  has_many :manager_transaction_histories, class_name: "TransactionHistory", foreign_key: "manager_id"
  has_many :freelancer_transaction_histories, class_name: "TransactionHistory", foreign_key: "freelancer_id"
  has_many :security_questions, :dependent => :destroy
  accepts_nested_attributes_for :security_questions

  scope :unverified_phones,  -> { where(phone_verified: false) }

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
      user_category: self.profile.try(:category),
      user_professional_title: self.profile.try(:professional_title),
      current_country: self.profile.try(:current_location_country),
      current_city: self.profile.try(:current_location_city),
      experience_level: self.profile.try(:experience_level),
      english_proficiency: self.profile.try(:english_proficiency),
      availability: self.profile.try(:availability),
      project_preference: self.profile.try(:project_preference)
    }
  end

  def create_username
    self.user_name = "#{self.first_name.downcase}_#{SecureRandom.random_number(1000)}"
    check_username(self.user_name)
  end

  def check_username(user_name)
    users = User.find_by(user_name: user_name)
    if users.present?
      create_username
    end
  end

  def mark_phone_as_verified!
    update!(phone_verified: true, phone_verification_code: nil)
  end

  def is_phone_verified?
    self.phone_verified
  end

  def send_sms_for_phone_verification
    PhoneVerification.new(user_id: id).send_sms
  end

  def set_phone_attributes
    self.phone_verification_code = generate_phone_verification_code

    # removes all white spaces, hyphens, and parenthesis
    self.phone_number.gsub!(/[\s\-\(\)]/, '')
    self.save!
  end

  private

  def generate_phone_verification_code
    begin
     verification_code = SecureRandom.hex(3)
    end while self.class.exists?(phone_verification_code: verification_code)

    verification_code
  end

end
