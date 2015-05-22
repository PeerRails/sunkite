ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  ENV['CONSUMER_KEY'] = ''
  ENV['CONSUMER_SECRET'] = ''
  ENV['ACCESS_TOKEN'] = ''
  ENV['ACCESS_TOKEN_SECRET'] = ''

  # Add more helper methods to be used by all tests here...
end
