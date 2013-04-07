class Notification
  include Mongoid::Document
  field :content, type: String

  embedded_in :user
end
