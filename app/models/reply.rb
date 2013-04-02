class Reply
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  embedded_in :post, class_name: 'Post', inverse_of: :replies
  
end
