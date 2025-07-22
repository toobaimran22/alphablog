class User < ApplicationRecord
    has_secure_password
    has_many :articles
    VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
    

    enum :role, { writer: "writer", editor: "editor", admin: "admin" }, suffix: true
  end
  