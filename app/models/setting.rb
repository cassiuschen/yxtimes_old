class Setting
  include Mongoid::Document

  mount_uploader :background, BackgroundUploader

  field :about, type: String

  default_scope desc(:created_at)
end
