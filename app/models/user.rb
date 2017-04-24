# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true

  has_many :subs

  after_initialize :ensure_session_token

  # password stuff
  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  #token stuff
  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  # find by credentials for controller use
  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil? || !user.is_password?(password)
    user
  end

end
