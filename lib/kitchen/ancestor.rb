module Kitchen
  class Ancestor

    attr_accessor :type
    attr_accessor :element_or_document

    def initialize(element_or_document)
      @element_or_document = element_or_document
      @type = element_or_document.short_type
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
      Ancestor.new(element_or_document)
    end

  end
end
