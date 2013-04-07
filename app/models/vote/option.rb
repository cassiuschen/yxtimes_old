class Vote::Option
  include Mongoid::Document

  field :content, type: String
  field :count, type: Integer

  embedded_in :vote
end
