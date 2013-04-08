class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :content, type: String
  field :source, type: String

  field :read_count, type: Integer, default: 0
  field :like_count, type: Integer, default: 0
  field :dislike_count, type: Integer, default: 0

  validates_presence_of :title

  field :_id, type: Integer, default: -> { Article.count + 1 }

  embeds_many :comments
  belongs_to :category
  belongs_to :author, class_name: "User", inverse_of: :articles


  before_save do |article|
    if article.source.match(/^http:\/\//i) || article.source.match(/^https:\/\//i) || article.source.match(/^ftp:\/\//i)
    else
      article.source = "http://" + article.source
    end
  end

  def read
    read_couny += 1
  end

  def liked_by(user)
    return if user.like_articles.include? self
    if user.dislike_articles.delete self
      self.dislike_count -= 1
    end
    user.like_articles << self
    self.like_count += 1
  end

  def disliked_by(user)
    return if user.dislike_articles.include? self
    if user.like_articles.delete self
      self.like_count -= 1
    end
    user.dislike_articles << self
    self.dislike_count += 1
  end

end
