class ReUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :re_skills, dependent: :destroy

  validates :d_comment, length: {maximum: 1000}
  validates :g_comment, length: {maximum: 1000}
  validates :name, presence: true, length: {maximum: 50}
end