#models/user.rb

class User
  include Mongoid::Document

  field :username, type: String
  field :email, type: String
  field :password, type: String

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

  index({ username: 'text' })

  scope :username, -> (username) { where(username: /^#{username}/) }
end