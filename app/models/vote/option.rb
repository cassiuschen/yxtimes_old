class Vote::Option
  include Mongoid::Document

  field :content, type: String
  field :count, type: Integer, default: 0

  validates_presence_of :content

  embedded_in :vote
end
