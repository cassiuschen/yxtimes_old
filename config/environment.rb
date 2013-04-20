# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Yxtimes::Application.initialize!

# RubyCAS-client
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://bdfz-cas.pkuschool.edu.cn:80/cas/",
  :validate_url => "http://bdfz-cas.pkuschool.edu.cn:80/cas/serviceValidate"
)
