# frozen_string_literal: true

require 'simplecov'

SimpleCov.start

ENV['TESTING'] = 'true'

if ENV['ENABLE_CODECOV']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'bundler/setup'

require 'openstax_kitchen'
require 'byebug'
require 'nokogiri/diff'
require 'rainbow'

Dir[File.expand_path("#{__dir__}/helpers/*.rb")].sort.each do |f|
  require f unless f.ends_with?('_spec.rb')
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include StubHelpers
  config.include FactoryHelpers
  config.include MatchHelpers
  config.include StringHelpers

  config.after(:suite) do
    Nokogiri::XML.print_profile_data if ENV['PROFILE']
  end
end
