class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :content, type: String

  validates_presence_of :title

  embeds_many :replies, class_name: 'Reply', inverse_of: :post

end
