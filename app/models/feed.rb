class Feed
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope desc(:created_at)

  field :content, type: String

  embedded_in :user
end
