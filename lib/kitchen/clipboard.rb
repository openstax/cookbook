module Kitchen
  class Clipboard

    attr_reader :items

    def self.named(name)
      (@instances ||= {})[name.to_sym] ||= new
    end

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

    # TODO include Enumerable
    def each(&block)
      @items.each do |item|
        Kitchen::Steps::Basic.new(node: item, &block).do_it
      end
    end

  end
end
