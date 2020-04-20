module Kitchen
  class Counter # hehe

    attr_reader :count

    def initialize
      reset
    end

    def increment
      @count += 1
    end

    def self.increment(name)
      (@has_been_incremented ||= {})[name.to_sym] = true
      instance!(name).increment
    end

    def reset
      @count = 0
    end

    def self.reset(name)
      instance!(name).reset
    end

    def self.read(name)
      if !has_been_incremented?(name)
        raise RecipeError, "Counter named '#{name}' cannot be read until started with `count :#{name}`"
      end

      instance!(name).count
    end

    protected

    def self.instance!(name)
      (@instances ||= {})[name.to_sym] ||= new
    end

    def self.has_been_incremented?(name)
      (@has_been_incremented ||= {})[name.to_sym]
    end

  end
end
