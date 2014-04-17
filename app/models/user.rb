class User
  include Mongoid::Document
  # Include default devise modules. Others available are: :database_authenticatable, :registerable,
  # :confirmable, :lockable, :timeoutable and :omniauthable, :rememberable, :validatable
  devise  :omniauthable, :recoverable, :trackable, :omniauth_providers => [:bdfzer],
            :authentication_keys => [:name] 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :password, :password_confirmation, :remember_me

  # Omniauth
  field :uid,   type: String
  field :provider, type: String
  field :email, type: String

  ## Database authenticatable
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :name, type: String
  validates_uniqueness_of :name

  attr_readonly :name
  field :_id, type: String, default: -> { name }
  
  field :nickname, type: String, default: -> { name }
  validates_presence_of :nickname

  field :power, type: Integer, default: 0
  attr_protected :power

  field :last_sign_in_at, :type => Time
  field :last_sign_in_ip, :type => String

  mount_uploader :avatar, AvatarUploader

  has_many :articles, inverse_of: :author
  embeds_many :notifications
  embeds_many :feeds

  def send_notification(notification, link)
    self.notifications.create!(content: notification, link: link)
  end

  def send_feed(feed)
    self.feeds.create!(content: feed)
  end

  def is_admin?
    !!(self.power >= 10)
  end

  def is_reporter?
    !!(self.power >= 1)
  end

  def is_teacher?
    !!(self.id.match(/^F.+/i))
  end

  def is_who
    if self.is_admin?
      "管理员"
    elsif self.is_teacher?
      "老师"
    elsif self.is_reporter?
      "记者"
    else
      "学生"
    end
  end

  def self.find_for_bdfzer_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.name = auth.uid
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.bdfzer_data"] && session["devise.bdfzer_data"]["extra"]["raw_info"]
        user.name = data["name"] if user.name.blank?
      end
    end
  end
end
