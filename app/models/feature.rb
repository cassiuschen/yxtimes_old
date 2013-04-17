class Feature
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :content, type: String

  mount_uploader :poster, FeatureUploader

  default_scope desc(:created_at)

  def comments_count
    articles.map(&:comments).flatten.count
  end

  has_and_belongs_to_many :articles, inverse_of: nil

  validates_presence_of :title, :articles
end
