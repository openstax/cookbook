# frozen_string_literal: true

module Kitchen
  module Mixins
    # A mixin for including the block_error_if method
    #
    # @example
    #   class SomeClass
    #     include Mixins::BlockErrorIf
    #
    #     def foo
    #       block_error_if(block_given?)
    #     end
    #   end
    module BlockErrorIf
      # All Ruby methods can take blocks, but not all of them use the block.  If a block is given but
      # not expected, we want to raise an error to help the developer figure out why their block isn't
      # doing what they expect.  The method does some work to figure out where the block was errantly
      # given to help the developer find the errant line of code.
      #
      # @param block_given [Boolean] true if block was given
      # @raise [RecipeError] if a block was given
      #
      def block_error_if(block_given)
        return unless block_given

        calling_method = begin
          this_method_location_index = caller_locations.find_index do |location|
            location.label == 'block_error_if'
          end

          caller_locations[(this_method_location_index || -1) + 1].label
        end

        raise(RecipeError, "The `#{calling_method}` method does not take a block")
      end
    end
  end
end
