require 'bundler/setup'
require 'fintoc'
require 'vcr'

VCR.configure do |c|
  vcr_mode = ENV['VCR_MODE'] =~ /rec/i ? :all : :once

  c.default_cassette_options = {
    record: vcr_mode,
    match_requests_on: %i[method uri body]
  }
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
