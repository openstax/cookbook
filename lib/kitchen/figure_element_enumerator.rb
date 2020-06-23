module Kitchen
  class FigureElementEnumerator < ElementEnumerator

    def self.within(element_or_document:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element_or_document: element_or_document,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "figure", # TODO element.document.selectors.figure
                                      sub_element_class: FigureElement)
    end

  end
end
