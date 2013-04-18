# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Yxtimes::Application.initialize!

# RubyCAS-client
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://127.0.0.1:8888/"
)
