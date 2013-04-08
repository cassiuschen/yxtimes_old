class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String

  embeds_many :options, class_name: "Vote::Option"
  embeds_many :comments
  belongs_to :author, class_name: "User"

end
