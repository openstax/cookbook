module Kitchen
  class Pantry

    def self.instance
      @instance ||= new
    end

    def store(item, label:)
      @hash[label.to_sym] = item
    end

    def get(label)
      @hash[label.to_sym] || raise(RecipeError, "There is no pantry item labeled '#{label}'")
    end

    protected

    def initialize
      @hash = {}
    end

  end
end
