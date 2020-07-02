module Kitchen
  class TermElementEnumerator < ElementEnumerator

    def self.within(element:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element: element,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "span[data-type='term']", # TODO element.document.selectors.term
                                      sub_element_class: TermElement)
    end

  end
end
