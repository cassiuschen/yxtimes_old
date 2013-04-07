class Category
  include Mongoid::Document

  field :name, type: String
  field :_id, type: String, default: -> { Category.count + 1 }

  has_many :articles

end
