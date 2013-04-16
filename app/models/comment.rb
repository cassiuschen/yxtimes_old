class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers

  field :content, type: String
  validates_presence_of :content

  embeds_many :subcomments, class_name: "SubComment"
  embedded_in :commentable, polymorphic: true
  belongs_to :commenter, class_name: "User"

  has_and_belongs_to_many :likers, class_name: 'User', inverse_of: nil
  has_and_belongs_to_many :dislikers, class_name: 'User', inverse_of: nil

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

  after_create :push_notifications
  def push_notifications
    return if !commentable.is_a?(Article)
    self.commentable.starrers.each do |user|
      user.send_notification("#{commenter.name} 评论了文章《#{commentable.title}》", article_path(commentable))
    end
  end
  
end
