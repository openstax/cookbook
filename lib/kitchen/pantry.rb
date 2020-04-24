module Kitchen
  # A place to store labeled items during recipe work.  Essentially, a slightly
  # improved hash.
  #
  class Pantry
    include Enumerable

    def store(item, label:)
      @hash[label.to_sym] = item
    end

    def get(label)
      @hash[label.to_sym] || raise(RecipeError, "There is no pantry item labeled '#{label}'")
    end

    def each(&block)
      @hash.each{|k,v| block.call(k,v)}
    end

    protected

    def initialize
      @hash = {}
    end

  end
end
