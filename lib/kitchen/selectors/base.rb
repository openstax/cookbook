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
      # Selector for the summary in a page
      # @return [String]
      attr_accessor :page_summary

      # Override specific selectors
      #
      # @param hash [Hash] a hash of selectors to selector values, e.g. {title_in_page: '.title'}
      # @return [Base] this object
      #
      def override(hash={})
        hash.each do |selector, value|
          send("#{selector}=", value)
        end
        self
      end
    end
  end
end
