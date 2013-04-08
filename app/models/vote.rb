class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String

  embeds_many :options, class_name: "Vote::Option"
  embeds_many :comments, inverse_of: nil
  belongs_to :author, class_name: "User"

  has_and_belongs_to_many :voters, class_name: "User", inverse_of: nil

  def already_voted_by?(user)
    voters.include? user
  end
end
