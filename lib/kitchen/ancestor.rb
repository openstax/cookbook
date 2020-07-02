module Kitchen
  class Ancestor

    attr_accessor :type
    attr_accessor :element

    def initialize(element)
      @element = element
      @type = element.short_type
      @descendant_counts = {}
    end

    def increment_descendant_count(descendant_type)
      @descendant_counts[descendant_type.to_sym] = get_descendant_count(descendant_type) + 1
    end

    def decrement_descendant_count(descendant_type, by: 1)
      @descendant_counts[descendant_type.to_sym] = get_descendant_count(descendant_type) - by
    end

    def get_descendant_count(descendant_type)
      @descendant_counts[descendant_type.to_sym] || 0
    end

    def clone
      Ancestor.new(element)
    end

  end
end
