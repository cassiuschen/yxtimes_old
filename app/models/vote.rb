class Vote
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :content, type: String
  field :read_count, type: Integer, default: 0

  field :max_vote, type: Integer, default: 1
  field :allow_anonymous, type: Boolean, default: false
  field :anonymous_voters_count, type: Integer, default: 0
  field :is_disabled, type: Boolean, default: false
  field :is_public, type: Boolean, default: true

  embeds_many :options, class_name: "Vote::Option"
  embeds_many :comments, as: :commentable
  belongs_to :author, class_name: "User"

  scope :hottest, desc(:read_count)
  scope :recent, desc(:created_at)

  validates_presence_of :title, :options

  accepts_nested_attributes_for :options, :allow_destroy => true

  has_and_belongs_to_many :voters, class_name: "User", inverse_of: nil

  def read
    update_attributes(read_count: read_count + 1)
  end

  def voters_count
    anonymous_voters_count + voters.count
  end
end
