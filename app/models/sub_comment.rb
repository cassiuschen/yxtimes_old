class SubComment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  embedded_in :comment
  belongs_to :commenter, class_name: "User"

end
