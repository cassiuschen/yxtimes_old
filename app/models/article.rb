class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :content, type: String
  field :source, type: String

  field :read_count, type: Integer

  validates_presence_of :title

  field :_id, type: Integer, default: -> { Article.count + 1 }

  embeds_many :comments
  belongs_to :category
  belongs_to :author, class_name: "User", inverse_of: :articles

end
