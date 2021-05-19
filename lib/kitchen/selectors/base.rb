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
      # Selector for a reference
      # @return [String]
      attr_accessor :reference
      # Selector for a chapter
      # @return [String]
      attr_accessor :chapter
      # Selector for a page
      # @return [String]
      attr_accessor :page
      # Selector for a note
      # @return [String]
      attr_accessor :note
      # Selector for a term
      # @return [String]
      attr_accessor :term
      # Selector for a table
      # @return [String]
      attr_accessor :table
      # Selector for a figure
      # @return [String]
      attr_accessor :figure
      # Selector for a metadata
      # @return [String]
      attr_accessor :metadata
      # Selector for a composite page
      # @return [String]
      attr_accessor :composite_page
      # Selector for a composite chapter
      # @return [String]
      attr_accessor :composite_chapter
      # Selector for an example
      # @return [String]
      attr_accessor :example
      # Selector for an exercise
      # @return [String]
      attr_accessor :exercise
      # Selector for an unit
      # @return [String]
      attr_accessor :unit

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
