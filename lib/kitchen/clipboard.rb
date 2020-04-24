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

    def add(item)
      @items.push(item)
    end

    def clear
      @items = []
    end

    def paste
      @items.map(&:to_s).join("")
    end

    def each(&block)
      @items.each do |item|
        block.call(item)
      end
    end
  end
end
