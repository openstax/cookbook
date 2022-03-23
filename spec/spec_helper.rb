# frozen_string_literal: true

ENV['TESTING'] = 'true'

if ENV['ENABLE_CODECOV']
  require 'simplecov'
  SimpleCov.start

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'bundler/setup'

require 'openstax_cookbook'
require 'byebug'
require 'nokogiri/diff'
require 'rainbow'
require 'recipes_spec/helpers/match_helper'
require 'nokogiri'

Dir[File.expand_path("#{__dir__}/kitchen_spec/helpers/*.rb")].sort.each do |f|
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

  config.snapshot_dir = 'spec/snapshots'

  config.include StubHelpers
  config.include FactoryHelpers
  config.include MatchHelpers
  config.include StringHelpers

  config.after(:suite) do
    Nokogiri::XML.print_profile_data if ENV['PROFILE']
  end
end
