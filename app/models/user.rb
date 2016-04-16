class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #before_save { self.email = email.downcase }
  before_create :create_remember_token
  before_create :set_updatedat_to_now
  #has_one :sps, dependent: :destroy
  has_many :skills, dependent: :destroy

  validates :d_comment, length: { maximum: 1000 }
  validates :g_comment, length: { maximum: 1000 }
  validates :name, presence: true, length: { maximum: 50 } 
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, presence: true,  format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #has_secure_password
  #validates :password, length: { minimum: 6 } 

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def set_updatedat_to_now
      self.skill_updated_at = Time.now
    end
end
