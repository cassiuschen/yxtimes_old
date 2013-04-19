class Setting
  include Mongoid::Document

  mount_uploader :background, BackgroundUploader

  default_scope desc(:created_at)
end
