class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers

  field :content, type: String
  field :ip, type: String
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

  after_create do

    if self.commentable.is_a?(Article)

      self.commentable.starrers.each do |user|
        next if user==self.commenter
        user.send_notification("#{commenter ? commenter.name : "匿名用户"} 评论了文章《#{commentable.title}》", article_path(commentable) + "##{self.id}")
      end
      self.commentable.starrers << self.commenter

      self.commenter.send_feed("评论了 <a href='#{category_path(commentable.category)}' class='link'>#{commentable.category.name}</a> 中的文章<a href='#{article_path(commentable)}' class='timeline-link'>《#{commentable.title}》</a>") if self.commenter
    
    else
      self.commenter.send_feed("评论了投票<a href='#{vote_path(commentable)}' class='timeline-link'>《#{commentable.title}》</a>") if self.commenter
    end
    
  end

end
