# frozen_string_literal: true

require 'zlib'

require 'bundler/setup'
require 'bundle_hack'
require 'rspec/its'
require 'webmock/rspec'

require 'byebug'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Dir[BundleHack.root.join('spec/support/**/*.rb')].each { |f| require f }
