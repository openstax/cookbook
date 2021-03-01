# frozen_string_literal: true
module Kitchen
  # A simple counting object
  #
  # hehe
  class Counter

    # Creates a new +Counter+ instance
    def initialize
      reset
    end

    # Increase the value of the counter
    #
    # @param by [Integer] the amount to increase by
    #
    def increment(by: 1)
      @value += by
    end

    # @!method inc
    #   @see increment
    alias_method :inc, :increment

    # Returns the value of the counter
    #
    # @return [Integer]
    def get
      @value
    end

    # Reset the value of the counter
    #
    # @param to [Integer] the value to reset to
    def reset(to: 0)
      @value = to
    end

  end
end
