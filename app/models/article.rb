include ActionView::Helpers::SanitizeHelper

class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :content, type: String
  field :source, type: String
  field :digest, type: String
  field :is_verified, type: Boolean, default: false

  default_scope where(is_verified: true)

  field :read_count, type: Integer, default: 0

  validates_presence_of :title, :content

  field :_id, type: Integer, default: -> { Article.count + 1 }

  embeds_many :comments, as: :commentable
  belongs_to :category
  belongs_to :author, class_name: "User", inverse_of: :articles
  validates_presence_of :author, :category

  has_and_belongs_to_many :likers, class_name: 'User', inverse_of: nil
  has_and_belongs_to_many :dislikers, class_name: 'User', inverse_of: nil
  has_and_belongs_to_many :starrers, class_name: 'User', inverse_of: nil

  # 返回文章中图片
  def imgs
    content.scan(/<img src=(.+?) alt>/).flatten
  end

  def score
    likers.count - dislikers.count
  end

  before_save do |article|
    article.digest = strip_tags(article.content)[0..80] + "……" if article.digest.blank?
    unless article.source.blank? || article.source.match(/^http:\/\//i) || article.source.match(/^https:\/\//i) || article.source.match(/^ftp:\/\//i)
      article.source = "http://" + article.source
    end
  end

  def read
    update_attributes(read_count: read_count + 1)
  end

  def liked_by?(user)
    likers.include? user
  end

  def disliked_by?(user)
    dislikers.include? user
  end

  def liked_by(user)
    return if likers.include? user
    dislikers.delete user
    likers << user
  end

  def disliked_by(user)
    return if dislikers.include? user
    likers.delete user
    dislikers << user
  end

  def starred_by?(user)
    starrers.include? user
  end

  def starred_by(user)
    return if starrers.include? user
    starrers << user
  end

  def is_verified?
    self.is_verified
  end

  def verify!
    self.update_attributes(is_verified: true)
  end
end
