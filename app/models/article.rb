class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :content, type: String
  field :source, type: String

  field :read_count, type: Integer, default: 0

  validates_presence_of :title

  field :_id, type: Integer, default: -> { Article.count + 1 }

  embeds_many :comments, inverse_of: nil
  belongs_to :category
  belongs_to :author, class_name: "User", inverse_of: :articles

  has_and_belongs_to_many :likers, class_name: 'User', inverse_of: nil
  has_and_belongs_to_many :dislikers, class_name: 'User', inverse_of: nil
  has_and_belongs_to_many :starrers, class_name: 'User', inverse_of: nil

  before_save do |article|
    unless article.source.match(/^http:\/\//i) || article.source.match(/^https:\/\//i) || article.source.match(/^ftp:\/\//i)
      article.source = "http://" + article.source
    end
  end

  def read
    read_count += 1
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

end
