class Feature
  include Mongoid::Document

  field :title, type: String
  field :content, type: String

  has_and_belongs_to_many :articles, inverse_of: nil

  before_save do |document|
    false if Feature.count > 0
  end
end
