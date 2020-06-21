module Kitchen
  class PageElementEnumerator < ElementEnumerator

    def terms
      TermElementEnumerator.chained_to_enumerator(self)
    end

    def self.within(element:)
      ElementEnumerator.within(enumerator_class: self,
                               element: element,
                               css_or_xpath: "div[data-type='page']", # TODO element.document.selectors.page
                               sub_element_wrapper_class: PageElement)
    end

    def self.chained_to_enumerator(other_enumerator)
      ElementEnumerator.chained_to_enumerator(enumerator_class: self,
                                              chained_to: other_enumerator)
    end

  end
end
