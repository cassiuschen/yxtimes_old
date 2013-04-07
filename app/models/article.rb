class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :content, type: String
  field :source, type: String

  validates_presence_of :title

  embeds_many :comments
  belongs_to :category
  belongs_to :author, class_name: "User"
  
end
