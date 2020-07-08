module Kitchen
  class Config

    attr_reader :selectors

    def self.new_from_file(file)
      raise "NYI"
    end

    def self.new_default
      new
    end

    def initialize(hash: {}, selectors: nil)
      @selectors = selectors || Kitchen::Selectors::Standard1.new
      @hash = hash
    end

  end
end
