module Kitchen
  class ChapterElementEnumerator < ElementEnumerator

    def pages
      PageElementEnumerator.chained_to_enumerator(self)
    end

    def self.within(element:)
      ElementEnumerator.within(enumerator_class: self,
                               element: element,
                               css_or_xpath: "div[data-type='chapter']",
                               sub_element_wrapper_class: ChapterElement)
    end

    def self.chained_to_enumerator(other_enumerator)
      ElementEnumerator.chained_to_enumerator(enumerator_class: self,
                                              chained_to: other_enumerator)
    end

  end
end
