class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.users.EMAIL_REGEX

  validates :name, presence: true,
    length: {maximum: Settings.users.name_maximum}
  validates :email, presence: true,
    length: {maximum: Settings.users.email_maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  before_save :downcase_email

  has_secure_password
  attr_accessor :remember_token

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Returns the hash digest of the given string.
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  private
  def downcase_email
    email.downcase!
  end
end
