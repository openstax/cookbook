# frozen_string_literal: true

require_relative '../imports_for_recipes'
require 'slop'
require_relative 'validate'

# Takes a block and silences any `puts` from that block
def silenced
  $stdout = StringIO.new

  yield
ensure
  $stdout = STDOUT
end
