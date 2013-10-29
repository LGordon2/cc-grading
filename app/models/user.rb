require 'net/ldap'

class User < ActiveRecord::Base
  has_many :submissions, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :username, presence:true, uniqueness: {case_sensitive: false}

  VALID_EMAIL_REGEX = %r{[a-zA-Z]+\.[a-zA-Z]+\@orasi\.com}
  validates_format_of :username, :with => VALID_EMAIL_REGEX , :message => "must be Orasi email address."
  #TODO this needs clean up bad...
  def self.authenticate(username, password)
    first_part_username,_ = username.split('@')
    ldap = Net::LDAP.new :host => '10.238.242.32',
    :port => 389,
    :auth => {
      :method => :simple,
      :username => "ORASI\\#{first_part_username}",
      :password => password
    }
    if ldap.bind
      user = User.find_by_username(username.downcase)

      if user
      return user
      else
        user = User.new
        user.username = username.downcase
        user.first_name,user.last_name = user.username.split('@').first.split('.')
        filter = Net::LDAP::Filter.eq("cn", "Perry*")
        treebase = "dc=orasi, dc=com"
        f = File.open(Rails.root.join('public', 'photos', user.first_name+user.last_name+'.jpg'), 'w')
        ldap.search(:base => treebase, :filter => filter).first["thumbnailphoto"].first.each_line {|line| f.puts line}
        f.close
        user.photo = '/photos/'+File.basename(f)
        user.save
      return user
      end
    end
    return nil
  end
end
