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

  end
end
