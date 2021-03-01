# frozen_string_literal: true

module Kitchen
  # A centralized place to put common CSS selectors so they aren't sprinkled
  # throughout the baseline (and so that they can be changed easily if needed)
  #
  module Selectors
    # Base class for different selector configurations
    #
    class Base
      # Selector for the title in a page
      # @return [String]
      attr_accessor :title_in_page
      # Selector for the title in an introduction page
      # @return [String]
      attr_accessor :title_in_introduction_page
    end
  end
end
