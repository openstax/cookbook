module Kitchen
  # An enumerator that detects the element type as it iterates and returns specific,
  # different element classes based on that type.
  #
  class TypeCastingElementEnumerator < ElementEnumeratorBase

    # Returns a factory for this enumerator
    #
    # @return [ElementEnumeratorFactory]
    #
    def self.factory
      ElementEnumeratorFactory.new(
        enumerator_class: self,
        detect_sub_element_class: true
      )
    end

    def only(*element_classes)
      element_classes.flatten!

      TypeCastingElementEnumerator.new do |block|
        self.each do |element|
          next unless element_classes.include?(element.class)
          block.yield(element)
        end
      end
    end

  end
end
