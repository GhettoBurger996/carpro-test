require "bcrypt"

class User < Sequel::Model
  include BCrypt
  plugin :validation_helpers

  def authenticate?(check_password)
    @password ||= Password.new(password_hash)
    @password == check_password
  end

  def password=(new_password)
    return if new_password == "" || new_password.nil?

    @_raw_password = new_password
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def admin?
    level >= 3
  end

  MIN_PASSWORD_LENGTH = 6

  def validate
    super
    validates_presence :username
    errors.add(:password, "length must be greater than #{MIN_PASSWORD_LENGTH}") if column_changed?(:password) && (@_raw_password.length || 0) <= MIN_PASSWORD_LENGTH
  end
end
