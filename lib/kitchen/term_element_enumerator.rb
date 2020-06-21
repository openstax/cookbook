module Kitchen
  class TermElementEnumerator < ElementEnumerator

    def self.within(element:)
      ElementEnumerator.within(enumerator_class: self,
                               element: element,
                               css_or_xpath: "span[data-type='term']",
                               sub_element_wrapper_class: TermElement)
    end

    def self.chained_to_enumerator(other_enumerator)
      ElementEnumerator.chained_to_enumerator(enumerator_class: self,
                                              chained_to: other_enumerator)
    end

  end
end
