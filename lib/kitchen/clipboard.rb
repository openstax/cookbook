module Kitchen
  # A place to store lists of things during recipe work.  Essentially a
  # slightly fancy array.
  #
  class Clipboard
    include Enumerable

    attr_reader :items

    def initialize
      clear
    end

    # Add an element to the clipboard
    # 
    # @param item [ElementBase]
    #
    def add(item)
      @items.push(item)
    end

    # Clears the clipboard
    #
    def clear
      @items = []
    end

    # Returns a concatenation of the pasting of each item on the clipboard
    # @return [String]
    #
    def paste
      @items.map(&:paste).join("")
    end

    # Iterates over each item on the clipboard
    # @yield each item
    # @return [Clipboard] self
    #
    def each(&block)
      @items.each do |item|
        block.call(item)
      end
      self
    end

    # Sorts the clipboard using the provided block
    # @yield each item
    # @return [Clipboard] self
    #
    def sort_by!(&block)
      @items.sort_by!(&block)
    end
  end
end
