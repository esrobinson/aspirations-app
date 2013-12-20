class User < ActiveRecord::Base
  attr_accessible :password, :username
  attr_reader :password

  before_validation :reset_session_token, :on => :create

  validates :username, :uniqueness => true
  validates :username, :password_digest, :session_token, :presence => true
  validates(
    :password,
    :presence => true,
    :length => { :minimum => 6 },
    :on => :create
  )

  has_many :goals

  def self.find_by_credentials(params)
    user = User.find_by_username(params[:username])
    return user if user && user.is_password?(params[:password])
    nil
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    reset_session_token
    self.save!
  end

end
