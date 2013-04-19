class Setting
  include Mongoid::Document

  mount_uploader :background, BackgroundUploader

  before_save do |file|
    false if Setting.count > 0
  end
end
