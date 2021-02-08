# frozen_string_literal: true

module Kitchen
  # A place to store labeled items during recipe work.  Essentially, a slightly
  # improved hash.
  #
  class Pantry
    include Enumerable

    # Adds an item to the pantry with the provided label
    #
    # @param item [Object] something to store
    # @param label [String, Symbol] a label with which to retrieve this item later.
    def store(item, label:)
      @hash[label.to_sym] = item
    end

    # Get an item from the pantry
    #
    # @param label [String, Symbol] the item's label
    # @return [Object]
    #
    def get(label)
      @hash[label.to_sym]
    end

    # Get an item from the pantry, raising if not present
    #
    # @param label [String, Symbol] the item's label
    # @raise [RecipeError] if there's no item for the label
    # @return [Object]
    #
    def get!(label)
      get(label) || raise(RecipeError, "There is no pantry item labeled '#{label}'")
    end

    # Iterate over the pantry items
    #
    # @yield Gives each label and item pair to the block
    # @yieldparam label [Symbol] the item's label
    # @yieldparam item [Object] the item
    #
    def each(&block)
      @hash.each { |k, v| block.call(k, v) }
    end

    # Returns the number of items in the pantry
    #
    # @return [Integer]
    #
    def size
      @hash.keys.size
    end

    protected

    def initialize
      @hash = {}
    end

  end
end
