class Vote
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :read_count, type: Integer, default: 0
  field :_id, type: Integer, default: -> { Vote.count + 1 }

  embeds_many :options, class_name: "Vote::Option"
  embeds_many :comments, as: :commentable
  belongs_to :author, class_name: "User"

  validates_presence_of :title, :options

  has_and_belongs_to_many :voters, class_name: "User", inverse_of: nil

  def read
    update_attributes(read_count: read_count + 1)
  end
  
  def already_voted_by?(user)
    voters.include? user
  end
end