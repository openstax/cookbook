require "bundler/setup"
require "kitchen"

require "byebug"
require "nokogiri/diff"
require "rainbow"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Dir[File.expand_path(__dir__ + "/helpers/*.rb")].each {|f| require f}

include StubHelpers
include FactoryHelpers
include MatchHelpers
