# frozen_string_literal: true

class User < ApplicationRecord
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password validations: true
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  validates :github_token, presence: true, length: { is: 40 }
end
