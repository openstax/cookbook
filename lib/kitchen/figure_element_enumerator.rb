module Kitchen
  class FigureElementEnumerator < ElementEnumerator

    def self.within(element:, css_or_xpath: nil)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element: element,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "figure", # TODO element.document.selectors.figure
                                      sub_element_class: FigureElement)
    end

  end
end
