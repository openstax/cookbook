module Kitchen
  class TypeCastingElementEnumerator < ElementEnumeratorBase

    def self.factory
      ElementEnumeratorFactory.new(
        enumerator_class: self,
        detect_sub_element_class: true
      )
    end

  end
end
