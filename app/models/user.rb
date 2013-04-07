class User
  include Mongoid::Document

  field :name, type: String
  validates :name, uniqueness: true

  attr_readonly :name
  field :_id, type: String, default: -> { name }
  
  field :nickname, type: String, default: -> { name }
  validates_presence_of :nickname

  field :sinature, type: String

  field :last_sign_in_at, :type => Time

  has_many :articles, inverse_of: :author

  has_and_belongs_to_many :star_articles, class_name: "Article", inverse_of: nil

  embeds_many :notifications
end
