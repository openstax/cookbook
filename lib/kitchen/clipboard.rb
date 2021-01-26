module Kitchen
  # A place to store lists of things during recipe work.  Essentially a
  # slightly fancy array.
  #
  class Clipboard
    include Enumerable

    # The underlying array
    # @return [Array<ElementBase>]
    #
    def items
      @items.clone
    end

    # Creates a new +Clipboard+
    #
    def initialize
      clear
    end

    # Add an element to the clipboard
    #
    # @param item [ElementBase]
    #
    def add(item)
      @items.push(item)
      self
    end

    # Clears the clipboard
    #
    def clear
      @items = []
      self
    end

    # Returns a concatenation of the pasting of each item on the clipboard
    # @return [String]
    #
    def paste
      @items.map(&:paste).join('')
    end

    # Iterates over each item on the clipboard
    # @yield each item
    # @return [Clipboard] self
    #
    def each(&block)
      @items.each do |item|
        block.call(item)
      end if block_given?
      self
    end

    # Sorts the clipboard using the provided block
    # @yield each item
    # @return [Clipboard] self
    #
    def sort_by!(&block)
      @items.sort_by!(&block)
      self
    end
  end
end
