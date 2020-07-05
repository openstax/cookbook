module Kitchen
  class ElementEnumerator < ElementEnumeratorBase

    def self.factory
      ElementEnumeratorFactory.new(
        sub_element_class: Element,
        enumerator_class: self
      )
    end

  end
end
