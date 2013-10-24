class User < ActiveRecord::Base
  include BCrypt
  
  has_many :submissions, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :username, presence:true, uniqueness: {case_sensitive: false}
  validates :password, presence:true, confirmation: true
  
  VALID_EMAIL_REGEX = %r{[a-zA-Z]+\.[a-zA-Z]+\@orasi\.com}
  validates_format_of :username, :with => VALID_EMAIL_REGEX , :message => "must be Orasi email address."

  def self.authenticate(username, password)
    user = User.find_by_username(username.downcase)
    return user && user.password == password ? user : nil
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
