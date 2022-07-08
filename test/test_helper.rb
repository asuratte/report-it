ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

Geocoder.configure(lookup: :test)
Geocoder::Lookup::Test.add_stub(
  "New York City, New York, 10007", [
    {
      'coordinates'  => [40.7143528, -74.0059731],
    }
  ]
)
Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'coordinates'  => [29.952211, -90.080563],
    }
  ]
)
