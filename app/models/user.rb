class User
  include Mongoid::Document

  field :name, type: String
  validates_uniqueness_of :name

  attr_readonly :name
  field :_id, type: String, default: -> { name }
  
  field :nickname, type: String, default: -> { name }
  validates_presence_of :nickname

  field :power, type: Integer, default: 0

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

  def is_who
    if self.is_admin?
      "老师"
    elsif self.is_reporter?
      "记者"
    else
      "学生"
    end
  end
end
