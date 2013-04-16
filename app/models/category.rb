class Category
  include Mongoid::Document

  field :name, type: String
  field :_id, type: String, default: -> { Category.count + 1 }

  has_many :articles

  def self.yuedu
    find_by(name: '阅读')
  end

  def self.guandian
    find_by(name: '观点')
  end

  def self.renwu
    find_by(name: '人物')
  end

  def self.diaocha
    find_by(name: '调查')
  end
end
