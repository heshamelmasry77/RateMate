class User < ApplicationRecord
  has_secure_password
  # enable password hashing with bcrypt

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
