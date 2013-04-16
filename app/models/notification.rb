class Notification
  include Mongoid::Document
  field :content, type: String

  field :read?, type: Boolean, default: false

  field :link, type: String

  def read
    update_attributes(read?: true)
  end

  default_scope where(read?: false)

  scope :readed, where(read?: true)

  embedded_in :user
end
