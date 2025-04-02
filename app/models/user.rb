class User < ApplicationRecord
  has_secure_password

  validates :full_name, :phone_number, :password, presence: true
  validates :phone_number, uniqueness: true

  validates :email, presence: true,
                    uniqueness: true,
                    format: {
                      with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/,
                      message: 'must be a valid email address'
                    } # validates: character before @, @ is present, a dot, characters after the do
end
