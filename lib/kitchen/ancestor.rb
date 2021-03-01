# frozen_string_literal: true
module Kitchen
  # A wrapper for an element representing an ancestor (up the DOM tree) of another
  # element; keeps track of the number of descendants it has of a particular type
  #
  class Ancestor

    # The type, e.g. +:page+, +:term+
    # @return [Symbol] the type
    #
    attr_reader :type

    # The ancestor element
    # @return [ElementBase] the ancestor element
    #
    attr_accessor :element

    # Create a new Ancestor
    #
    # @param element [ElementBase] the ancestor element
    #
    def initialize(element)
      @element = element
      @type = element.short_type
      @descendant_counts = {}
    end

    # Adds 1 to the descendant count for the given type
    #
    # @param descendant_type [String, Symbol] the descendent's type
    #
    def increment_descendant_count(descendant_type)
      @descendant_counts[descendant_type.to_sym] = get_descendant_count(descendant_type) + 1
    end

    # Decreases the descendant count for the given type by some amount
    #
    # @param descendant_type [String, Symbol] the descendent's type
    # @param by [Integer] the amount by which to decrement
    # @raise [RangeError] if descendant count is a negative number
    #
    def decrement_descendant_count(descendant_type, by: 1)
      if get_descendant_count(descendant_type) - by >= 0
        @descendant_counts[descendant_type.to_sym] = get_descendant_count(descendant_type) - by
      else
        raise(RangeError, 'An element cannot have negative descendants')
      end
    end

    # Returns the descendant count for the given type
    #
    # @param descendant_type [String, Symbol] the descendent's type
    # @return [Integer] the count
    #
    def get_descendant_count(descendant_type)
      @descendant_counts[descendant_type.to_sym] || 0
    end

    # Makes a new Ancestor around the same element, with new counts
    #
    def clone
      # @todo Delete later if not used
      Ancestor.new(element)
    end

  end
end
