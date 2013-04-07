class Category
  include Mongoid::Document

  field :name, type: String
  field :en_name, type: String
  field :_id, type: String, default: -> { en_name }

  has_many :articles

end
