class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :seasons
  has_many :teams

  validates :username, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true, uniqueness: true
end
