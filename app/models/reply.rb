class Reply
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  embedded_in :article, class_name: 'Article', inverse_of: :replies
  
end
