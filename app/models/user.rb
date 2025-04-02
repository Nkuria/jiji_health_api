class User < ApplicationRecord
  has_secure_password

  validates :full_name, :phone_number, :email, :password, presence: true
  validates :email, :phone_number, uniqueness: true
end