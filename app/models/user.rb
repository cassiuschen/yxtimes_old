class User
  include Mongoid::Document

  field :name, type: String
  field :nickname, type: String
  
  field :sinature, type: String

  field :last_sign_in_at,    :type => Time

  
end
