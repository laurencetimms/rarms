#models/user.rb

class User
  include Mongoid::Document

  field :username, type: String
  field :email, type: String
  field :password_hash, type: String # only store the hash of the password; compare hashed passwords on authenticate

  validates :username, presence: true
  validates :email, presence: true
  validates :password_hash, presence: true

  index({name: 1}, {unique: true, name: 'user_name_index'})

  include BCrypt
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

end
